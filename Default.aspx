<%@ Page Title="Главная страница" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Laba4._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <section class="row mb-5" aria-labelledby="aspnetTitle">
            <div class="col-md-12 text-center py-5 bg-light rounded-3 shadow-lg hero-section">
                <h1 id="aspnetTitle" class="display-4 fw-bold text-gradient"><i class="fas fa-calendar-alt me-3"></i>Календарь студенческих событий</h1>
                <p class="lead mt-3 text-secondary">Просмотр и регистрация на предстоящие студенческие мероприятия в университете.</p>
            </div>
        </section>

        <div class="row mb-5 gx-4">
            <div class="col-md-8">
                <div class="card shadow-lg h-100 border-0 rounded-3 hover-card">
                    <div class="card-header bg-gradient-primary text-white py-3">
                        <h2 id="calendarTitle" class="h4 mb-0"><i class="fas fa-info-circle me-2"></i>О календаре событий</h2>
                    </div>
                    <div class="card-body p-4">
                        <p class="lead">
                            Просмотрите все предстоящие студенческие мероприятия, ознакомьтесь с деталями и зарегистрируйтесь для участия.
                            Будьте в курсе всех активностей и не упустите возможность участвовать в жизни университетского сообщества.
                        </p>
                        <a href="Calendar.aspx" class="btn btn-outline-primary mt-3 d-inline-flex align-items-center hover-btn">
                            <i class="fas fa-calendar me-2"></i> Перейти к календарю
                            <i class="fas fa-arrow-right ms-2 btn-icon-move"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-lg h-100 border-0 rounded-3 bg-light hover-card">
                    <div class="card-body text-center p-4">
                        <i class="fas fa-university fa-4x text-primary mb-3 icon-float"></i>
                        <h3 class="h5 fw-bold">Участвуйте в мероприятиях</h3>
                        <p>Расширяйте свои знания, заводите новых друзей и получайте ценный опыт</p>
                        <hr class="my-3 colored-hr">
                        <div class="d-flex justify-content-center gap-3">
                            <span class="badge bg-primary p-2 scale-on-hover"><i class="fas fa-users me-1"></i> Нетворкинг</span>
                            <span class="badge bg-success p-2 scale-on-hover"><i class="fas fa-lightbulb me-1"></i> Опыт</span>
                            <span class="badge bg-info p-2 scale-on-hover"><i class="fas fa-book me-1"></i> Знания</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-5">
            <div class="col-md-12">
                <div class="card shadow-lg border-0 rounded-4 overflow-hidden">
                    <div class="card-header bg-gradient-primary text-white p-3">
                        <h3 class="mb-0"><i class="fas fa-star me-2"></i>Предстоящие события</h3>
                    </div>
                    <div class="card-body p-4">
                        <asp:ListView ID="UpcomingEventsListView" runat="server" OnItemCommand="UpcomingEventsListView_ItemCommand">
                            <EmptyDataTemplate>
                                <div class="alert alert-info d-flex align-items-center">
                                    <i class="fas fa-info-circle me-3 fa-2x"></i>
                                    <div>
                                        <h4 class="alert-heading">Нет событий</h4>
                                        <p class="mb-0">Предстоящие события не запланированы. Загляните позже!</p>
                                    </div>
                                </div>
                            </EmptyDataTemplate>
                            <ItemTemplate>
                                <div class="event-item mb-4 p-4 border-start border-4 border-primary rounded-3 shadow-sm event-card clickable-event" 
                                     data-event-date='<%# DateTime.Parse(Eval("StartDate").ToString()).ToString("yyyy-MM-dd") %>'
                                     data-event-id='<%# Eval("ID") %>'
                                     data-event-title='<%# Eval("Title") %>'
                                     data-event-description='<%# Eval("Description") %>'
                                     data-event-location='<%# Eval("Location") %>'
                                     data-event-start='<%# DateTime.Parse(Eval("StartDate").ToString()).ToString("dd.MM.yyyy HH:mm") %>'
                                     data-event-end='<%# DateTime.Parse(Eval("EndDate").ToString()).ToString("dd.MM.yyyy HH:mm") %>'
                                     data-event-category='<%# Eval("Category") %>'
                                     data-event-attendees='<%# Eval("CurrentAttendees") %> / <%# Eval("MaxAttendees") %>'>
                                    <div class="row">
                                        <div class="col-md-9">
                                            <h4 class="text-primary fw-bold"><%# Eval("Title") %></h4>
                                            <p class="text-muted mt-2 mb-3"><%# Eval("Description") %></p>
                                            <div class="d-flex flex-wrap gap-4 mt-3 text-muted">
                                                <p class="mb-0"><i class="fas fa-calendar-day me-2"></i> <%# DateTime.Parse(Eval("StartDate").ToString()).ToString("dddd, d MMMM yyyy", new System.Globalization.CultureInfo("ru-RU")) %></p>
                                                <p class="mb-0"><i class="fas fa-clock me-2"></i> <%# DateTime.Parse(Eval("StartDate").ToString()).ToShortTimeString() %> - <%# DateTime.Parse(Eval("EndDate").ToString()).ToShortTimeString() %></p>
                                                <p class="mb-0"><i class="fas fa-map-marker-alt me-2"></i> <%# Eval("Location") %></p>
                                            </div>
                                            <div class="mt-3">
                                                <span class="badge bg-light text-primary border border-primary attendees-badge">
                                                    <i class="fas fa-users me-1"></i> 
                                                    <%# Eval("CurrentAttendees") %> / <%# Eval("MaxAttendees") %> участников
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-md-3 text-end align-self-center">
                                            <asp:LinkButton ID="SelectEventButton" runat="server" 
                                                CssClass="btn btn-primary btn-hover-effect event-details-btn" 
                                                CommandName="SelectEvent" 
                                                CommandArgument='<%# DateTime.Parse(Eval("StartDate").ToString()).ToString("yyyy-MM-dd") + "|" + Eval("ID") %>'>
                                                <i class="fas fa-info-circle me-2"></i> Подробнее
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Модальное окно для просмотра информации о событии -->
    <div class="modal fade" id="eventDetailsModal" tabindex="-1" aria-labelledby="eventDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header bg-gradient-primary text-white">
                    <h5 class="modal-title" id="eventDetailsModalLabel">Информация о событии</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row">
                        <div class="col-md-12 mb-4">
                            <h3 id="modalEventTitle" class="text-primary fw-bold"></h3>
                            <hr class="colored-hr mt-2 mb-4">
                        </div>
                        <div class="col-md-12 mb-4">
                            <h5 class="fw-bold"><i class="fas fa-align-left me-2 text-muted"></i>Описание</h5>
                            <p id="modalEventDescription" class="ms-4 mt-2"></p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-bold"><i class="fas fa-calendar-day me-2 text-muted"></i>Дата начала</h5>
                            <p id="modalEventStart" class="ms-4 mt-2"></p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-bold"><i class="fas fa-calendar-check me-2 text-muted"></i>Дата окончания</h5>
                            <p id="modalEventEnd" class="ms-4 mt-2"></p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-bold"><i class="fas fa-map-marker-alt me-2 text-muted"></i>Место проведения</h5>
                            <p id="modalEventLocation" class="ms-4 mt-2"></p>
                        </div>
                        <div class="col-md-6 mb-4">
                            <h5 class="fw-bold"><i class="fas fa-tag me-2 text-muted"></i>Категория</h5>
                            <p id="modalEventCategory" class="ms-4 mt-2"></p>
                        </div>
                        <div class="col-md-12">
                            <h5 class="fw-bold"><i class="fas fa-users me-2 text-muted"></i>Участники</h5>
                            <p id="modalEventAttendees" class="ms-4 mt-2"></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
                    <a id="modalMoreDetailsBtn" href="#" class="btn btn-primary">
                        <i class="fas fa-external-link-alt me-2"></i>Подробнее
                    </a>
                </div>
            </div>
        </div>
    </div>

    <style>
        .bg-gradient-primary {
            background: linear-gradient(135deg, #3498db, #1a5276);
        }
        
        .bg-gradient-secondary {
            background: linear-gradient(135deg, #2c3e50, #34495e);
        }
        
        .text-gradient {
            background: linear-gradient(135deg, #3498db, #8e44ad);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .hero-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-bottom: 5px solid #3498db;
            position: relative;
            overflow: hidden;
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
        
        .event-card {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            background-color: #fff;
        }
        
        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1) !important;
            border-left-color: #27ae60 !important;
        }
        
        .event-card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(52, 152, 219, 0.05), rgba(39, 174, 96, 0.05));
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .event-card:hover:before {
            opacity: 1;
        }
        
        .clickable-event {
            cursor: pointer;
        }
        
        .btn-hover-effect {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .btn-hover-effect:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .hover-card {
            transition: all 0.3s ease;
        }
        
        .hover-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important;
        }
        
        .scale-on-hover {
            transition: transform 0.3s ease;
        }
        
        .scale-on-hover:hover {
            transform: scale(1.1);
        }
        
        .icon-float {
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }
        
        .pulse-btn {
            animation: pulse 2s infinite;
            position: relative;
            overflow: hidden;
        }
        
        .pulse-btn:after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.2);
            transform: scale(0);
            border-radius: 50%;
            transition: transform 0.5s;
        }
        
        .pulse-btn:hover:after {
            transform: scale(2);
        }
        
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(52, 152, 219, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(52, 152, 219, 0); }
            100% { box-shadow: 0 0 0 0 rgba(52, 152, 219, 0); }
        }
        
        .rounded-3 {
            border-radius: 0.5rem !important;
        }
        
        .rounded-4 {
            border-radius: 0.75rem !important;
        }
        
        .colored-hr {
            background-image: linear-gradient(to right, #3498db, #27ae60);
            height: 3px;
            border: none;
            opacity: 0.5;
        }
        
        .btn-icon-move {
            transition: transform 0.3s ease;
        }
        
        .hover-btn:hover .btn-icon-move {
            transform: translateX(5px);
        }
        
        .hover-btn {
            transition: all 0.3s ease;
        }
        
        .hover-btn:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .hover-btn-alt {
            transition: all 0.3s ease;
            border-radius: 0 0.375rem 0.375rem 0;
        }
        
        .hover-btn-alt:hover {
            background-color: #1a5276;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        
        .attendees-badge {
            transition: all 0.3s ease;
        }
        
        .attendees-badge:hover {
            transform: scale(1.05);
            background-color: #f8f9fa;
        }
        
        @media (max-width: 768px) {
            .hero-section h1 {
                font-size: 1.8rem;
            }
            
            .hero-section p.lead {
                font-size: 1rem;
            }
            
            .event-item {
                padding: 1rem !important;
            }
            
            .event-item h4 {
                font-size: 1.2rem;
            }
            
            .event-item .text-muted {
                font-size: 0.9rem;
            }
            
            .event-item .d-flex {
                flex-direction: column;
                gap: 0.5rem !important;
            }
            
            .event-item .col-md-3 {
                text-align: left !important;
                margin-top: 1rem;
            }
            
            .event-item .btn {
                width: 100%;
                margin-top: 0.5rem;
            }
            
            .attendees-badge {
                margin-top: 0.5rem;
                display: inline-block;
            }
        }
        
        @media (max-width: 576px) {
            .hero-section {
                padding: 1.5rem 0 !important;
            }
            
            .hero-section h1 {
                font-size: 1.5rem;
            }
            
            .card-header h3, .card-header h2 {
                font-size: 1.2rem;
            }
            
            .card-body {
                padding: 1rem !important;
            }
            
            .badge {
                padding: 0.3rem 0.5rem !important;
                font-size: 0.7rem !important;
            }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function() {
            $('.hover-card').addClass('active-permanent');
            
            var eventElements = $('.event-card');
            eventElements.css('opacity', '0').css('transform', 'translateY(20px)');
            
            setTimeout(function() {
                eventElements.addClass('active');
            }, 300);
            
            function animateOnScroll() {
                var events = document.querySelectorAll('.event-card');
                
                for (var i = 0; i < events.length; i++) {
                    var windowHeight = window.innerHeight;
                    var elementTop = events[i].getBoundingClientRect().top;
                    var elementBottom = events[i].getBoundingClientRect().bottom;
                    
                    if (elementTop < windowHeight - 100 && elementTop > 0) {
                        events[i].classList.add('active');
                    } 
                    else if (elementTop < 0 || elementTop > windowHeight) {
                        events[i].classList.remove('active');
                    }
                }
            }
            
            window.addEventListener('scroll', animateOnScroll);
            
            // Обработчик клика по событию для открытия модального окна
            $('.clickable-event').on('click', function(e) {
                // Проверяем, не был ли клик по кнопке "Подробнее"
                if (!$(e.target).closest('.event-details-btn').length) {
                    e.preventDefault();
                    
                    // Получаем данные о событии из атрибутов data-*
                    var eventId = $(this).data('event-id');
                    var eventDate = $(this).data('event-date');
                    var eventTitle = $(this).data('event-title');
                    var eventDescription = $(this).data('event-description');
                    var eventLocation = $(this).data('event-location');
                    var eventStart = $(this).data('event-start');
                    var eventEnd = $(this).data('event-end');
                    var eventCategory = $(this).data('event-category');
                    var eventAttendees = $(this).data('event-attendees');
                    
                    // Заполняем модальное окно данными
                    $('#modalEventTitle').text(eventTitle);
                    $('#modalEventDescription').text(eventDescription);
                    $('#modalEventStart').text(eventStart);
                    $('#modalEventEnd').text(eventEnd);
                    $('#modalEventLocation').text(eventLocation);
                    $('#modalEventCategory').text(eventCategory);
                    $('#modalEventAttendees').text(eventAttendees);
                    
                    // Настраиваем ссылку "Подробнее"
                    $('#modalMoreDetailsBtn').attr('href', 'Calendar.aspx?date=' + eventDate + '&eventId=' + eventId);
                    
                    // Открываем модальное окно
                    var eventModal = new bootstrap.Modal(document.getElementById('eventDetailsModal'));
                    eventModal.show();
                }
            });
        });
    </script>
    
    <style>
        .event-card.active {
            opacity: 1 !important;
            transform: translateY(0) !important;
            transition: all 0.5s ease;
        }
        
        .hover-card.active-permanent {
            opacity: 1 !important;
            transform: translateY(0) !important;
        }
    </style>

</asp:Content>
