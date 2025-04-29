using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.IO;
using System.Drawing;
using System.Globalization;

namespace Laba4
{
    public partial class AdminCalendar : System.Web.UI.Page
    {
        private string xmlFilePath;
        private XDocument eventsDoc;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Проверяем, что пользователь аутентифицирован и имеет роль администратора
            if (!User.Identity.IsAuthenticated || !User.IsInRole("Admin"))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            
            xmlFilePath = Server.MapPath("~/App_Data/Events.xml");
            
            if (File.Exists(xmlFilePath))
            {
                eventsDoc = XDocument.Load(xmlFilePath);
            }
            else
            {
                eventsDoc = new XDocument(
                    new XDeclaration("1.0", "utf-8", null),
                    new XElement("Events")
                );
                eventsDoc.Save(xmlFilePath);
            }

            if (!IsPostBack)
            {
                BindEventsGrid();
                ResetForm();
            }
        }
        
        private void BindEventsGrid()
        {
            var events = eventsDoc.Descendants("Event")
                .Select(ev => new
                {
                    ID = ev.Element("ID").Value,
                    Title = ev.Element("Title").Value,
                    StartDate = DateTime.Parse(ev.Element("StartDate").Value),
                    Location = ev.Element("Location").Value,
                    Attendees = string.Format("{0}/{1}", 
                        ev.Element("Attendees")?.Elements("Student")?.Count() ?? 0,
                        ev.Element("MaxAttendees").Value)
                })
                .OrderBy(e => e.StartDate)
                .ToList();

            EventsGridView.DataSource = events;
            EventsGridView.DataBind();
        }
        
        private void ResetForm()
        {
            EventIdHiddenField.Value = string.Empty;
            TitleTextBox.Text = string.Empty;
            DescriptionTextBox.Text = string.Empty;
            StartDateTextBox.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm");
            EndDateTextBox.Text = DateTime.Now.AddHours(1).ToString("yyyy-MM-ddTHH:mm");
            LocationTextBox.Text = string.Empty;
            MaxAttendeesTextBox.Text = "50";
            FormTitleLiteral.Text = "Добавить новое событие";
        }

        protected void SaveButton_Click(object sender, EventArgs evt)
        {
            if (Page.IsValid && Page.Validators.Cast<BaseValidator>().Where(v => v.ValidationGroup == "EventForm").All(v => v.IsValid))
            {
                string id = EventIdHiddenField.Value;
                bool isEditing = !string.IsNullOrEmpty(id);
                
                if (!isEditing)
                {
                    id = Guid.NewGuid().ToString().Substring(0, 8);
                }
                
                DateTime startDate;
                DateTime endDate;
                
                if (!DateTime.TryParse(StartDateTextBox.Text, out startDate) ||
                    !DateTime.TryParse(EndDateTextBox.Text, out endDate))
                {
                    ShowErrorMessage("Неверный формат даты. Используйте выбор даты.");
                    return;
                }
                
                if (endDate <= startDate)
                {
                    DateCompareValidator.IsValid = false;
                    return;
                }
                
                int maxAttendees;
                if (!int.TryParse(MaxAttendeesTextBox.Text, out maxAttendees) || maxAttendees < 1)
                {
                    ShowErrorMessage("Неверное значение максимального количества участников. Введите положительное число.");
                    return;
                }
                
                if (isEditing)
                {
                    XElement eventElement = eventsDoc.Descendants("Event")
                        .FirstOrDefault(e => e.Element("ID").Value == id);
                        
                    if (eventElement != null)
                    {
                        eventElement.Element("Title").Value = TitleTextBox.Text.Trim();
                        eventElement.Element("Description").Value = DescriptionTextBox.Text.Trim();
                        eventElement.Element("StartDate").Value = startDate.ToString("o");
                        eventElement.Element("EndDate").Value = endDate.ToString("o");
                        eventElement.Element("Location").Value = LocationTextBox.Text.Trim();
                        eventElement.Element("MaxAttendees").Value = maxAttendees.ToString();
                    }
                }
                else
                {
                    XElement newEvent = new XElement("Event",
                        new XElement("ID", id),
                        new XElement("Title", TitleTextBox.Text.Trim()),
                        new XElement("Description", DescriptionTextBox.Text.Trim()),
                        new XElement("StartDate", startDate.ToString("o")),
                        new XElement("EndDate", endDate.ToString("o")),
                        new XElement("Location", LocationTextBox.Text.Trim()),
                        new XElement("MaxAttendees", maxAttendees.ToString()),
                        new XElement("Attendees")
                    );
                    
                    eventsDoc.Root.Add(newEvent);
                }
                
                eventsDoc.Save(xmlFilePath);
                
                ResetForm();
                BindEventsGrid();
                
                ShowSuccessMessage(isEditing ? "Событие успешно обновлено." : "Событие успешно добавлено.");
            }
        }
        
        protected void CancelButton_Click(object sender, EventArgs e)
        {
            ResetForm();
        }
        
        protected void EventsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string eventId = e.CommandArgument.ToString();
            
            if (e.CommandName == "EditEvent")
            {
                XElement eventElement = eventsDoc.Descendants("Event")
                    .FirstOrDefault(ev => ev.Element("ID").Value == eventId);
                    
                if (eventElement != null)
                {
                    EventIdHiddenField.Value = eventId;
                    TitleTextBox.Text = eventElement.Element("Title").Value;
                    DescriptionTextBox.Text = eventElement.Element("Description").Value;
                    
                    DateTime startDate = DateTime.Parse(eventElement.Element("StartDate").Value);
                    DateTime endDate = DateTime.Parse(eventElement.Element("EndDate").Value);
                    
                    StartDateTextBox.Text = startDate.ToString("yyyy-MM-ddTHH:mm");
                    EndDateTextBox.Text = endDate.ToString("yyyy-MM-ddTHH:mm");
                    
                    LocationTextBox.Text = eventElement.Element("Location").Value;
                    MaxAttendeesTextBox.Text = eventElement.Element("MaxAttendees").Value;
                    
                    FormTitleLiteral.Text = "Редактировать событие";
                }
            }
            else if (e.CommandName == "ViewAttendees")
            {
                try
                {
                    XElement eventElement = eventsDoc.Descendants("Event")
                        .FirstOrDefault(ev => ev.Element("ID")?.Value == eventId);
                        
                    if (eventElement != null)
                    {
                        string eventTitle = eventElement.Element("Title")?.Value ?? "Событие";
                        XElement attendeesElement = eventElement.Element("Attendees");
                        
                        if (attendeesElement != null && attendeesElement.HasElements)
                        {
                            var attendees = attendeesElement.Elements("Student")
                                .Select(student => new
                                {
                                    ID = student.Attribute("ID")?.Value ?? "Нет данных",
                                    Name = student.Attribute("Name")?.Value ?? "Нет данных",
                                    Email = student.Attribute("Email")?.Value ?? "Нет данных",
                                    RegistrationDate = DateTime.TryParse(student.Attribute("RegistrationDate")?.Value, out DateTime regDate) 
                                        ? regDate : DateTime.Now
                                })
                                .OrderBy(a => a.RegistrationDate)
                                .ToList();
                            
                            AttendeesGridView.DataSource = attendees;
                        }
                        else
                        {
                            // If no students are registered, set an empty list
                            AttendeesGridView.DataSource = new List<object>();
                        }
                        
                        AttendeesGridView.DataBind();
                        
                        // Add event title to the modal
                        ScriptManager.RegisterStartupScript(this, GetType(), "SetModalTitle", 
                            $"document.getElementById('attendeesModalLabel').innerText = 'Участники: {HttpUtility.JavaScriptStringEncode(eventTitle)}';", true);
                        
                        // Show the modal with Bootstrap 5
                        ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", 
                            "setTimeout(function() { showAttendeesModal(); }, 100);", true);
                    }
                    else
                    {
                        ShowErrorMessage("Событие не найдено.");
                    }
                }
                catch (Exception ex)
                {
                    ShowErrorMessage($"Ошибка при загрузке списка участников: {ex.Message}");
                }
            }
        }
        
        protected void EventsGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = EventsGridView.Rows[e.RowIndex];
            string eventId = row.Cells[0].Text;
            
            XElement eventToRemove = eventsDoc.Descendants("Event")
                .FirstOrDefault(ev => ev.Element("ID").Value == eventId);
                
            if (eventToRemove != null)
            {
                eventToRemove.Remove();
                eventsDoc.Save(xmlFilePath);
                
                BindEventsGrid();
                ResetForm();
                
                ShowSuccessMessage("Событие успешно удалено.");
            }
        }
        
        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SuccessMessage", 
                $"alert('{message}');", true);
        }
        
        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ErrorMessage", 
                $"alert('{message}');", true);
        }
    }
} 