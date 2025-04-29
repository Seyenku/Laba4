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
                                <div class="event-item mb-4 p-4 border-start border-4 border-primary rounded-3 shadow-sm event-card" 
                                     data-event-date='<%# DateTime.Parse(Eval("StartDate").ToString()).ToString("yyyy-MM-dd") %>'>
                                    <div class="row">
                                        <div class="col-md-9">
                                            <h4 class="text-primary fw-bold"><%# Eval("Title") %></h4>
                                            <p class="text-muted mt-2 mb-3"><%# Eval("Description") %></p>
                                            <div class="d-flex flex-wrap gap-4 mt-3 text-muted">
                                                <p class="mb-0"><i class="fas fa-calendar-day me-2"></i> <%# DateTime.Parse(Eval("StartDate").ToString()).ToString("dddd, d MMMM yyyy", new System.Globalization.CultureInfo("ru-RU")) %></p>
                                                <p class="mb-0"><i class="fas fa-clock me-2"></i> <%# DateTime.Parse(Eval("StartDate").ToString()).ToShortTimeString() %> - <%# DateTime.Parse(Eval("EndDate").ToString()).ToShortTimeString() %></p>
                                                <p class="mb-0"><i class="fas fa-map-marker-alt me-2"></i> <%# Eval("Location") %></p>
                                                <p class="mb-0"><i class="fas fa-tag me-2"></i> <%# Eval("Category") %></p>
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
                                                CssClass="btn btn-primary btn-hover-effect" 
                                                CommandName="SelectEvent" 
                                                CommandArgument='<%# DateTime.Parse(Eval("StartDate").ToString()).ToString("yyyy-MM-dd") %>'>
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
            cursor: pointer;
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
    </style>

    <script type="text/javascript">
        $(document).ready(function() {
            // Клик по карточке события
            $('.event-card').click(function(e) {
                // Only trigger if not clicking the button itself
                if (!$(e.target).closest('.btn').length) {
                    var eventDate = $(this).data('event-date');
                    window.location.href = 'Calendar.aspx?date=' + eventDate;
                }
            });
            
            // Плавное появление элементов при загрузке страницы
            $('.event-card, .hover-card').css('opacity', '0').css('transform', 'translateY(20px)');
            
            setTimeout(function() {
                $('.event-card, .hover-card').addClass('active');
            }, 300);
            
            // Добавляем класс active при прокрутке, но не удаляем его
            function revealOnScroll() {
                var reveals = document.querySelectorAll('.event-card:not(.active), .hover-card:not(.active)');
                
                for (var i = 0; i < reveals.length; i++) {
                    var windowHeight = window.innerHeight;
                    var elementTop = reveals[i].getBoundingClientRect().top;
                    var elementVisible = 150;
                    
                    if (elementTop < windowHeight - elementVisible) {
                        reveals[i].classList.add('active');
                    }
                }
            }
            
            window.addEventListener('scroll', revealOnScroll);
        });
    </script>
    
    <style>
        .event-card.active, .hover-card.active {
            opacity: 1 !important;
            transform: translateY(0) !important;
            transition: all 0.8s ease;
        }
    </style>

</asp:Content>
