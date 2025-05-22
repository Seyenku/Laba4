<%@ Page Title="Календарь студенческих событий" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="Laba4.Calendar" Async="true" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row">
            <div class="col-md-12 text-center py-4 mb-4 bg-light rounded-3 shadow-sm hero-section">
                <h2 class="display-5 fw-bold text-gradient"><i class="fas fa-calendar-alt me-3"></i>Календарь студенческих событий</h2>
                <p class="lead">Просмотрите предстоящие студенческие мероприятия и зарегистрируйтесь для участия!</p>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-6 offset-md-3">
                <div class="input-group">
                    <asp:TextBox ID="DateSearchTextBox" runat="server" CssClass="form-control" placeholder="Выберите дату" TextMode="Date"></asp:TextBox>
                    <asp:Button ID="SearchByDateButton" runat="server" CssClass="btn btn-primary" Text="Поиск" OnClick="SearchByDateButton_Click" />
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card shadow-sm rounded-3 overflow-hidden mb-4">
                    <div class="card-header bg-gradient-primary text-white py-3">
                        <h3 class="mb-0 h5"><i class="fas fa-calendar-week me-2"></i>Выберите дату</h3>
                    </div>
                    <div class="card-body p-0">
                        <asp:Calendar ID="EventCalendar" runat="server" Width="100%" BackColor="White" 
                            BorderColor="#e9ecef" CellPadding="8" DayNameFormat="Short" 
                            Font-Names="'Segoe UI', Arial, sans-serif" Font-Size="12pt" ForeColor="#333" Height="550px" 
                            OnDayRender="EventCalendar_DayRender" OnSelectionChanged="EventCalendar_SelectionChanged"
                            FirstDayOfWeek="Monday" NextPrevFormat="FullMonth" CssClass="modern-calendar" 
                            SelectionMode="Day">
                            <DayHeaderStyle BackColor="#f8f9fa" Font-Bold="True" Font-Size="11pt" CssClass="day-header" />
                            <NextPrevStyle Font-Bold="True" Font-Size="13pt" ForeColor="White" VerticalAlign="Middle" CssClass="next-prev" />
                            <OtherMonthDayStyle ForeColor="#adb5bd" />
                            <SelectedDayStyle BackColor="#2c73d2" Font-Bold="True" ForeColor="White" CssClass="selected-day" />
                            <SelectorStyle BackColor="#f8f9fa" Font-Bold="True" Font-Size="12pt" ForeColor="#333" />
                            <TitleStyle BackColor="#2c3e50" Font-Bold="True" Font-Size="14pt" ForeColor="White" Height="50px" CssClass="calendar-title" />
                            <TodayDayStyle BackColor="#e74c3c" ForeColor="White" CssClass="today-day" />
                            <WeekendDayStyle BackColor="#f8f9fa" />
                        </asp:Calendar>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-12">
                <asp:Panel ID="EventDetailsPanel" runat="server" Visible="false" CssClass="card shadow-sm rounded-3 overflow-hidden">
                    <div class="card-header bg-gradient-primary text-white py-3 d-flex justify-content-between align-items-center">
                        <h3 class="mb-0 h5"><i class="fas fa-list-alt me-2"></i>События на <asp:Label ID="SelectedDateLabel" runat="server" CssClass="fw-bold"></asp:Label></h3>
                    </div>
                    <div class="card-body p-4">
                        <asp:Repeater ID="EventsRepeater" runat="server">
                            <ItemTemplate>
                                <div id="event-<%# Eval("ID") %>" class="event-item mb-4 p-4 rounded-3 border-start border-4 border-primary shadow-sm hover-card">
                                    <h4 class="text-primary fw-bold"><%# Eval("Title") %></h4>
                                    <div class="row mt-3 mb-3">
                                        <div class="col-md-6">
                                            <p class="mb-2"><i class="fas fa-clock text-secondary me-2"></i> <strong>Время:</strong> <%# DateTime.Parse(Eval("StartDate").ToString()).ToShortTimeString() %> - <%# DateTime.Parse(Eval("EndDate").ToString()).ToShortTimeString() %></p>
                                            <p class="mb-2"><i class="fas fa-map-marker-alt text-danger me-2"></i> <strong>Место проведения:</strong> <%# Eval("Location") %></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="mb-2"><i class="fas fa-users text-success me-2"></i> <strong>Доступные места:</strong> <span class="badge bg-success"><%# GetAvailableSpots(Eval("MaxAttendees"), Eval("ID")) %></span></p>
                                            <p class="mb-2"><i class="fas fa-hashtag text-info me-2"></i> <strong>ID события:</strong> <code><%# Eval("ID") %></code></p>
                                        </div>
                                    </div>
                                    <div class="card mb-3 bg-light border-0 rounded-3">
                                        <div class="card-body">
                                            <h5 class="card-title text-secondary"><i class="fas fa-info-circle me-2"></i>Описание</h5>
                                            <p class="card-text"><%# Eval("Description") %></p>
                                        </div>
                                    </div>
                                    
                                    <% if (Request.IsAuthenticated) { %>
                                    <asp:Panel ID="RegisterPanel" runat="server" Visible='<%# IsRegistrationAvailable(Eval("ID"), Eval("MaxAttendees")) %>'>
                                        <div class="card border-primary rounded-3 shadow-sm">
                                            <div class="card-header bg-primary text-white py-3">
                                                <h5 class="mb-0"><i class="fas fa-user-plus me-2"></i>Регистрация на событие</h5>
                                            </div>
                                            <div class="card-body p-4">
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
                                                        CssClass="btn btn-primary btn-lg hover-btn" OnClick="RegisterButton_Click" 
                                                        CommandArgument='<%# Eval("ID") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    
                                    <asp:Panel ID="FullEventPanel" runat="server" Visible='<%# !IsRegistrationAvailable(Eval("ID"), Eval("MaxAttendees")) %>'>
                                        <div class="alert alert-warning d-flex align-items-center">
                                            <i class="fas fa-exclamation-triangle me-3 fa-2x"></i>
                                            <div>
                                                <strong>Внимание!</strong> Это мероприятие уже заполнено.
                                            </div>
                                        </div>
                                    </asp:Panel>
                                    <% } else { %>
                                    <div class="alert alert-info d-flex align-items-center">
                                        <i class="fas fa-info-circle me-3 fa-2x"></i>
                                        <div>
                                            <strong>Внимание!</strong> Для регистрации на событие необходимо <a href="Login.aspx" class="alert-link">войти в систему</a>.
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                                <hr class="my-4" />
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Panel ID="NoEventsPanel" runat="server" Visible="false">
                            <div class="alert alert-info d-flex align-items-center">
                                <i class="fas fa-info-circle me-3 fa-2x"></i>
                                <div>
                                    <h4 class="alert-heading">Нет событий</h4>
                                    <p class="mb-0">На эту дату событий не запланировано.</p>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="eventsModal" tabindex="-1" aria-labelledby="eventsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="eventsModalLabel">События на выбранную дату</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                </div>
                <div class="modal-body" id="eventsModalBody">
                    <!-- Сюда будут подставляться события -->
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
                </div>
            </div>
            </div>
        </div>
    </main>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            var calendar = document.querySelector('.modern-calendar');
            if (!calendar) return;
            
            calendar.addEventListener('click', function(e) {
                var cell = e.target.closest('td');
                if (!cell) return;
                
                var link = cell.querySelector('a');
                if (link && e.target !== link) {
                    e.preventDefault();
                    link.click();
                }
            });
            
            if (typeof Sys !== 'undefined' && Sys.WebForms) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
                    var cells = document.querySelectorAll('.modern-calendar td');
                    cells.forEach(function(cell) {
                        if (cell.querySelector('a')) {
                            cell.style.cursor = 'pointer';
                        }
                    });
                });
            }
        });

        function showEventsModal(events) {
            var modalBody = document.getElementById('eventsModalBody');
            if (!modalBody) return;

            if (!events || events.length === 0) {
                modalBody.innerHTML = `
            <div class="alert alert-info">На выбранную дату событий не найдено.</div>
        `;
            } else {
                var html = '';
                events.forEach(function (event) {
                    html += `
                <div class="event-item mb-4 p-3 border rounded-3">
                    <h5 class="text-primary">${event.Title}</h5>
                    <p><strong>Время:</strong> ${new Date(event.StartDate).toLocaleTimeString()} - ${new Date(event.EndDate).toLocaleTimeString()}</p>
                    <p><strong>Место:</strong> ${event.Location}</p>
                    <p><strong>Описание:</strong> ${event.Description}</p>
                </div>
                <hr/>
            `;
                });
                modalBody.innerHTML = html;
            }
            var modal = new bootstrap.Modal(document.getElementById('eventsModal'));
            modal.show();
        }

        // Функция для получения событий через AJAX
        function getEventsByDate(date) {
            var formattedDate = formatDate(date);
            fetch('EventService.svc/GetEvents?date=' + formattedDate)
                .then(response => response.json())
                .then(data => {
                    updateEventsDisplay(data);
                })
                .catch(error => {
                    console.error('Error fetching events:', error);
                    showError('Ошибка при загрузке событий');
                });
        }

        // Форматирование даты в формат dd.MM.yyyy
        function formatDate(date) {
            var day = date.getDate().toString().padStart(2, '0');
            var month = (date.getMonth() + 1).toString().padStart(2, '0');
            var year = date.getFullYear();
            return day + '.' + month + '.' + year;
        }

        // Обновление отображения событий
        function updateEventsDisplay(events) {
            var eventsContainer = document.querySelector('.card-body');
            if (!eventsContainer) return;

            if (events.length === 0) {
                eventsContainer.innerHTML = `
                    <div class="alert alert-info d-flex align-items-center">
                        <i class="fas fa-info-circle me-3 fa-2x"></i>
                        <div>
                            <h4 class="alert-heading">Нет событий</h4>
                            <p class="mb-0">На эту дату событий не запланировано.</p>
                        </div>
                    </div>`;
                return;
            }

            var eventsHtml = '';
            events.forEach(function(event) {
                eventsHtml += `
                    <div id="event-${event.ID}" class="event-item mb-4 p-4 rounded-3 border-start border-4 border-primary shadow-sm hover-card">
                        <h4 class="text-primary fw-bold">${event.Title}</h4>
                        <div class="row mt-3 mb-3">
                            <div class="col-md-6">
                                <p class="mb-2"><i class="fas fa-clock text-secondary me-2"></i> <strong>Время:</strong> ${new Date(event.StartDate).toLocaleTimeString()} - ${new Date(event.EndDate).toLocaleTimeString()}</p>
                                <p class="mb-2"><i class="fas fa-map-marker-alt text-danger me-2"></i> <strong>Место проведения:</strong> ${event.Location}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-2"><i class="fas fa-users text-success me-2"></i> <strong>Доступные места:</strong> <span class="badge bg-success">${event.MaxAttendees - event.CurrentAttendees}</span></p>
                                <p class="mb-2"><i class="fas fa-hashtag text-info me-2"></i> <strong>ID события:</strong> <code>${event.ID}</code></p>
                            </div>
                        </div>
                        <div class="card mb-3 bg-light border-0 rounded-3">
                            <div class="card-body">
                                <h5 class="card-title text-secondary"><i class="fas fa-info-circle me-2"></i>Описание</h5>
                                <p class="card-text">${event.Description}</p>
                            </div>
                        </div>
                    </div>
                    <hr class="my-4" />`;
            });

            eventsContainer.innerHTML = eventsHtml;
        }

        // Отображение ошибки
        function showError(message) {
            var eventsContainer = document.querySelector('.card-body');
            if (!eventsContainer) return;

            eventsContainer.innerHTML = `
                <div class="alert alert-danger d-flex align-items-center">
                    <i class="fas fa-exclamation-circle me-3 fa-2x"></i>
                    <div>
                        <h4 class="alert-heading">Ошибка</h4>
                        <p class="mb-0">${message}</p>
                    </div>
                </div>`;
        }
    </script>

    <style>
        .bg-gradient-primary {
            background: linear-gradient(135deg, #3498db, #1a5276);
        }
        
        .text-gradient {
            background: linear-gradient(135deg, #3498db, #8e44ad);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .hero-section {
            position: relative;
            overflow: hidden;
            border-bottom: 5px solid #3498db;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="40" stroke="%233498db" stroke-width="2" fill="none" opacity="0.2" /></svg>') 0 0 / 100px 100px;
            opacity: 0.2;
            z-index: 0;
        }
        
        .hero-section > * {
            position: relative;
            z-index: 1;
        }
        
        .modern-calendar {
            border-spacing: 5px;
            border-collapse: separate;
            overflow: hidden;
        }
        
        .modern-calendar td {
            border-radius: 5px;
            transition: all 0.2s ease;
            cursor: pointer;
            position: relative;
            transform-origin: center center;
        }
        
        .modern-calendar td a {
            display: block;
            width: 100%;
            height: 100%;
            z-index: 2;
            text-decoration: none;
            color: inherit;
            font-weight: bold;
        }
        
        .modern-calendar td:hover {
            background-color: #e9ecef;
            transform: scale(1.01);
        }
        
        .modern-calendar td.has-events {
            position: relative;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        
        .modern-calendar td.has-events:hover {
            background-color: #c3e6cb;
            transform: scale(1.02);
        }
        
        .day-header {
            border-radius: 5px 5px 0 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .calendar-title {
            border-radius: 5px 5px 0 0;
        }
        
        .event-count {
            position: absolute;
            top: 2px;
            right: 2px;
            background-color: #28a745;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .hover-card {
            transition: all 0.3s ease;
        }
        
        .hover-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .hover-btn {
            transition: all 0.3s ease;
        }
        
        .hover-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</asp:Content> 