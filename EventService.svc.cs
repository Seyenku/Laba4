using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Xml.Linq;
using System.IO;
using System.Runtime.Serialization;

namespace Laba4
{
    [ServiceContract]
    public interface IEventService
    {
        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "GetEvents?date={date}")]
        List<EventData> GetEvents(string date);
    }

    [DataContract]
    public class EventData
    {
        [DataMember]
        public string ID { get; set; }

        [DataMember]
        public string Title { get; set; }

        [DataMember]
        public string Description { get; set; }

        [DataMember]
        public string StartDate { get; set; }

        [DataMember]
        public string EndDate { get; set; }

        [DataMember]
        public string Location { get; set; }

        [DataMember]
        public int MaxAttendees { get; set; }

        [DataMember]
        public int CurrentAttendees { get; set; }
    }

    public class EventService : IEventService
    {
        public List<EventData> GetEvents(string date)
        {
            try
            {
                DateTime selectedDate;
                if (!DateTime.TryParseExact(date, "dd.MM.yyyy", null, System.Globalization.DateTimeStyles.None, out selectedDate))
                {
                    throw new FaultException("Invalid date format. Please use dd.MM.yyyy format.");
                }

                string xmlFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data", "Events.xml");
                if (!File.Exists(xmlFilePath))
                {
                    return new List<EventData>();
                }

                XDocument eventsDoc = XDocument.Load(xmlFilePath);
                var events = eventsDoc.Descendants("Event")
                    .Where(ev => DateTime.Parse(ev.Element("StartDate").Value).Date == selectedDate.Date)
                    .Select(ev => new EventData
                    {
                        ID = ev.Element("ID").Value,
                        Title = ev.Element("Title").Value,
                        Description = ev.Element("Description").Value,
                        StartDate = ev.Element("StartDate").Value,
                        EndDate = ev.Element("EndDate").Value,
                        Location = ev.Element("Location").Value,
                        MaxAttendees = int.Parse(ev.Element("MaxAttendees").Value),
                        CurrentAttendees = ev.Element("Attendees")?.Elements("Student").Count() ?? 0
                    })
                    .ToList();

                return events;
            }
            catch (Exception ex)
            {
                throw new FaultException($"Error retrieving events: {ex.Message}");
            }
        }
    }
} 