using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using System.IO;

namespace Laba4
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUpcomingEvents();
            }
        }

        private void LoadUpcomingEvents()
        {
            try
            {
                // Загрузка XML-файла с событиями
                string xmlPath = Server.MapPath("~/App_Data/Events.xml");
                
                if (!File.Exists(xmlPath))
                {
                    // Обработка случая, когда файл не существует
                    ShowErrorMessage("Файл событий не найден. Пожалуйста, создайте события в календаре.");
                    return;
                }
                
                XDocument eventsXml = XDocument.Load(xmlPath);

                // Получение текущей даты
                DateTime today = DateTime.Today;

                // Выборка предстоящих событий (сегодня и позже)
                var upcomingEvents = from eventNode in eventsXml.Descendants("Event")
                                    let startDate = DateTime.Parse(eventNode.Element("StartDate").Value)
                                    where startDate >= today
                                    orderby startDate
                                    select new
                                    {
                                        ID = eventNode.Element("ID")?.Value ?? Guid.NewGuid().ToString().Substring(0, 8),
                                        Title = eventNode.Element("Title").Value,
                                        Description = eventNode.Element("Description").Value,
                                        StartDate = startDate,
                                        EndDate = DateTime.Parse(eventNode.Element("EndDate").Value),
                                        Location = eventNode.Element("Location").Value,
                                        Category = eventNode.Element("Category")?.Value ?? "Общее",
                                        MaxAttendees = int.Parse(eventNode.Element("MaxAttendees")?.Value ?? "0"),
                                        CurrentAttendees = eventNode.Element("Attendees")?.Elements("Student")?.Count() ?? 0
                                    };

                var events = upcomingEvents.ToList();
                
                if (events.Count == 0)
                {
                    // Обработка случая, когда нет предстоящих событий
                    ShowInfoMessage("В настоящий момент нет запланированных событий. Загляните позже!");
                }
                
                // Привязка данных к ListView
                UpcomingEventsListView.DataSource = events.Take(5); // Ограничиваем количество отображаемых событий
                UpcomingEventsListView.DataBind();
            }
            catch (Exception ex)
            {
                // Обработка ошибок при загрузке или обработке XML
                ShowErrorMessage("Произошла ошибка при загрузке событий: " + ex.Message);
                LogError(ex);
            }
        }

        protected void UpcomingEventsListView_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "SelectEvent")
            {
                string eventDate = e.CommandArgument.ToString();
                Response.Redirect($"Calendar.aspx?date={eventDate}");
            }
        }
        
        private void ShowErrorMessage(string message)
        {
            // Добавьте здесь логику отображения сообщения об ошибке
            // Например, через встроенный элемент управления для уведомлений
            ScriptManager.RegisterStartupScript(this, GetType(), 
                "errorAlert", $"alert('Ошибка: {message.Replace("'", "\\'")}')", true);
        }
        
        private void ShowInfoMessage(string message)
        {
            // Добавьте здесь логику отображения информационного сообщения
            ScriptManager.RegisterStartupScript(this, GetType(), 
                "infoAlert", $"console.log('Информация: {message.Replace("'", "\\'")}')", true);
        }
        
        private void LogError(Exception ex)
        {
            // Логирование ошибок в файл или другую систему логирования
            string logPath = Server.MapPath("~/App_Data/ErrorLog.txt");
            string errorMessage = $"{DateTime.Now}: {ex.Message}\r\n{ex.StackTrace}\r\n\r\n";
            
            try
            {
                File.AppendAllText(logPath, errorMessage);
            }
            catch
            {
                // Игнорируем ошибки при логировании
            }
        }
    }
}