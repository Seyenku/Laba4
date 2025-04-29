<%@ Page Title="Календарь студенческих событий" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="Laba4.Calendar" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row">
            <div class="col-md-12 text-center py-4 mb-4 bg-light rounded-3 shadow-sm hero-section">
                <h2 class="display-5 fw-bold text-gradient"><i class="fas fa-calendar-alt me-3"></i>Календарь студенческих событий</h2>
                <p class="lead">Просмотрите предстоящие студенческие мероприятия и зарегистрируйтесь для участия!</p>
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
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .selected-day {
            border-radius: 5px;
            transform: scale(1.03) !important;
            box-shadow: 0 5px 20px rgba(44, 115, 210, 0.4) !important;
            position: relative;
            z-index: 3;
            animation: selected-pulse 2s infinite alternate;
        }
        
        .selected-day a, .selected-day a:hover, .selected-day a:visited {
            color: white !important;
            font-weight: bold;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
        }
        
        @keyframes selected-pulse {
            0% {
                box-shadow: 0 5px 15px rgba(44, 115, 210, 0.4);
            }
            100% {
                box-shadow: 0 5px 25px rgba(44, 115, 210, 0.7);
            }
        }
        
        .next-prev {
            padding: 10px;
            border-radius: 5px;
        }
        
        .hover-card {
            transition: all 0.3s ease;
        }
        
        .hover-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
        }
        
        .hover-btn {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .hover-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .event-count {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: #3498db;
            color: white;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            z-index: 1;
            pointer-events: none;
        }
        
        .today-day {
            border-radius: 5px;
            transform: scale(1.02);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        
        .today-day a, .today-day a:hover, .today-day a:visited {
            color: white !important;
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .hero-section h2 {
                font-size: 1.8rem;
            }
            
            .hero-section p.lead {
                font-size: 1rem;
            }
            
            .modern-calendar {
                font-size: 10pt !important;
            }
            
            .modern-calendar td {
                padding: 5px !important;
            }
            
            .card-header h3 {
                font-size: 1.2rem;
            }
            
            .event-item {
                padding: 1rem !important;
            }
            
            .event-item h4 {
                font-size: 1.2rem;
            }
            
            .row .col-md-6 {
                margin-bottom: 1rem;
            }
            
            .col-form-label {
                padding-bottom: 0.25rem;
            }
            
            .row.mb-3 {
                margin-bottom: 1rem !important;
            }
        }
        
        @media (max-width: 576px) {
            .hero-section {
                padding: 1.5rem 0 !important;
            }
            
            .modern-calendar {
                font-size: 9pt !important;
            }
            
            .modern-calendar td {
                padding: 3px !important;
            }
            
            .event-count {
                width: 18px;
                height: 18px;
                font-size: 10px;
            }
            
            .card-body {
                padding: 0.75rem !important;
            }
            
            .btn {
                padding: 0.375rem 0.75rem;
                font-size: 0.9rem;
            }
            
            .col-sm-3 {
                width: 100%;
                margin-bottom: 0.25rem;
            }
            
            .col-sm-9 {
                width: 100%;
            }
            
            .card-header {
                padding: 0.75rem 1rem !important;
            }
        }
    </style>
</asp:Content> 