<%@ Page Title="Календарь студенческих событий" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="Laba4.Calendar" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row">
            <div class="col-md-12">
                <h2>Календарь студенческих событий</h2>
                <p class="lead">Просмотрите предстоящие студенческие мероприятия и зарегистрируйтесь для участия!</p>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-12">
                <!-- Calendar Control -->
                <asp:Calendar ID="EventCalendar" runat="server" Width="100%" BackColor="White" 
                    BorderColor="#999999" CellPadding="4" DayNameFormat="Shortest" 
                    Font-Names="Verdana" Font-Size="12pt" ForeColor="Black" Height="550px" 
                    OnDayRender="EventCalendar_DayRender" OnSelectionChanged="EventCalendar_SelectionChanged"
                    FirstDayOfWeek="Monday" NextPrevFormat="FullMonth">
                    <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="10pt" />
                    <NextPrevStyle Font-Bold="True" Font-Size="12pt" ForeColor="White" VerticalAlign="Bottom" />
                    <OtherMonthDayStyle ForeColor="#999999" />
                    <SelectedDayStyle BackColor="#3498db" Font-Bold="True" ForeColor="White" />
                    <SelectorStyle BackColor="#CCCCCC" Font-Bold="True" Font-Names="Verdana" Font-Size="12pt" ForeColor="#333333" />
                    <TitleStyle BackColor="#2c3e50" Font-Bold="True" Font-Size="14pt" ForeColor="White" />
                    <TodayDayStyle BackColor="#e74c3c" ForeColor="White" />
                    <WeekendDayStyle BackColor="#f7f7f7" />
                </asp:Calendar>
            </div>
        </div>

        <!-- Event Details Panel (initially hidden) -->
        <div class="row mt-4">
            <div class="col-md-12">
                <asp:Panel ID="EventDetailsPanel" runat="server" Visible="false" CssClass="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">События на <asp:Label ID="SelectedDateLabel" runat="server" CssClass="fw-bold"></asp:Label></h3>
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="EventsRepeater" runat="server">
                            <ItemTemplate>
                                <div class="event-item mb-4 p-3 rounded border-start border-4 border-primary shadow-sm">
                                    <h4 class="text-primary"><%# Eval("Title") %></h4>
                                    <div class="row mt-3 mb-3">
                                        <div class="col-md-6">
                                            <p><i class="fas fa-clock"></i> <strong>Время:</strong> <%# DateTime.Parse(Eval("StartDate").ToString()).ToShortTimeString() %> - <%# DateTime.Parse(Eval("EndDate").ToString()).ToShortTimeString() %></p>
                                            <p><i class="fas fa-map-marker-alt"></i> <strong>Место проведения:</strong> <%# Eval("Location") %></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><i class="fas fa-users"></i> <strong>Доступные места:</strong> <span class="badge bg-success"><%# GetAvailableSpots(Eval("MaxAttendees"), Eval("ID")) %></span></p>
                                            <p><i class="fas fa-calendar-check"></i> <strong>ID события:</strong> <code><%# Eval("ID") %></code></p>
                                        </div>
                                    </div>
                                    <div class="card mb-3 bg-light">
                                        <div class="card-body">
                                            <h5 class="card-title">Описание</h5>
                                            <p class="card-text"><%# Eval("Description") %></p>
                                        </div>
                                    </div>
                                    
                                    <asp:Panel ID="RegisterPanel" runat="server" Visible='<%# IsRegistrationAvailable(Eval("ID"), Eval("MaxAttendees")) %>'>
                                        <div class="card border-primary">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">Регистрация на событие</h5>
                                            </div>
                                            <div class="card-body">
                                                <asp:HiddenField ID="EventIdField" runat="server" Value='<%# Eval("ID") %>' />
                                                <div class="row mb-3">
                                                    <label class="col-sm-3 col-form-label">Ваше имя:</label>
                                                    <div class="col-sm-9">
                                                        <asp:TextBox ID="StudentNameTextBox" runat="server" CssClass="form-control" placeholder="Ваше имя" ReadOnly="true"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <label class="col-sm-3 col-form-label">Студенческий ID:</label>
                                                    <div class="col-sm-9">
                                                        <asp:TextBox ID="StudentIdTextBox" runat="server" CssClass="form-control" placeholder="Студенческий ID" ReadOnly="true"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <label class="col-sm-3 col-form-label">Email:</label>
                                                    <div class="col-sm-9">
                                                        <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" placeholder="Email" ReadOnly="true"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="d-grid gap-2">
                                                    <asp:Button ID="RegisterButton" runat="server" Text="Участвовать" 
                                                        CssClass="btn btn-primary btn-lg" OnClick="RegisterButton_Click" 
                                                        CommandArgument='<%# Eval("ID") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    
                                    <asp:Panel ID="FullEventPanel" runat="server" Visible='<%# !IsRegistrationAvailable(Eval("ID"), Eval("MaxAttendees")) %>'>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle"></i> <strong>Внимание!</strong> Это мероприятие уже заполнено.
                                        </div>
                                    </asp:Panel>
                                </div>
                                <hr />
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Panel ID="NoEventsPanel" runat="server" Visible="false">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> На эту дату событий не запланировано.
                            </div>
                        </asp:Panel>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </main>

    <!-- Modal for Event Details -->
    <div class="modal fade" id="eventModal" tabindex="-1" role="dialog" aria-labelledby="eventModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="eventModalLabel">Детали события</h5>

                </div>
                <div class="modal-body" id="eventModalBody">
                    <!-- Event details will be populated dynamically via JavaScript -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" data-dismiss="modal">Закрыть</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // JavaScript for handling event details modal
        function showEventDetails(eventId, title, description, startTime, endTime, location, maxAttendees, currentAttendees) {
            var content = "<h4>" + title + "</h4>";
            content += "<p><strong>Время:</strong> " + startTime + " - " + endTime + "</p>";
            content += "<p><strong>Место проведения:</strong> " + location + "</p>";
            content += "<p>" + description + "</p>";
            content += "<p><strong>Доступные места:</strong> " + (maxAttendees - currentAttendees) + " из " + maxAttendees + "</p>";
            
            document.getElementById("eventModalLabel").innerText = title;
            document.getElementById("eventModalBody").innerHTML = content;
            
            // Show the modal using different Bootstrap versions
            if (typeof bootstrap !== 'undefined') {
                // Bootstrap 5
                var myModal = new bootstrap.Modal(document.getElementById('eventModal'));
                myModal.show();
            } else if (typeof $ !== 'undefined' && typeof $.fn.modal !== 'undefined') {
                // Bootstrap 4 or 3
                $('#eventModal').modal('show');
            } else {
                // Fallback
                document.getElementById('eventModal').style.display = 'block';
            }
        }
    </script>
</asp:Content> 