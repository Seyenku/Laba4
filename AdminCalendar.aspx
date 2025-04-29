<%@ Page Title="Панель администратора календаря" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminCalendar.aspx.cs" Inherits="Laba4.AdminCalendar" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row">
            <div class="col-md-12">
                <h2>Администрирование календаря событий</h2>
                <p class="lead">Управление студенческими мероприятиями в календаре</p>
            </div>
        </div>

        <!-- Event List Panel -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h3>Текущие события</h3>
                    </div>
                    <div class="card-body">
                        <asp:GridView ID="EventsGridView" runat="server" CssClass="table table-striped table-bordered" 
                            AutoGenerateColumns="false" OnRowCommand="EventsGridView_RowCommand"
                            OnRowDeleting="EventsGridView_RowDeleting">
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" />
                                <asp:BoundField DataField="Title" HeaderText="Название" />
                                <asp:BoundField DataField="StartDate" HeaderText="Дата начала" DataFormatString="{0:g}" />
                                <asp:BoundField DataField="Location" HeaderText="Место проведения" />
                                <asp:BoundField DataField="Attendees" HeaderText="Участники" />
                                <asp:TemplateField HeaderText="Действия">
                                    <ItemTemplate>
                                        <asp:Button ID="ViewAttendeesButton" runat="server" Text="Участники" 
                                            CommandName="ViewAttendees" CommandArgument='<%# Eval("ID") %>' 
                                            CssClass="btn btn-info btn-sm" CausesValidation="false" />
                                        <asp:Button ID="EditButton" runat="server" Text="Изменить" 
                                            CommandName="EditEvent" CommandArgument='<%# Eval("ID") %>' 
                                            CssClass="btn btn-primary btn-sm" CausesValidation="false" />
                                        <asp:Button ID="DeleteButton" runat="server" Text="Удалить" 
                                            CommandName="Delete" CommandArgument='<%# Eval("ID") %>' 
                                            CssClass="btn btn-danger btn-sm" CausesValidation="false"
                                            OnClientClick="return confirm('Вы уверены, что хотите удалить это событие?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="alert alert-info">События не найдены. Используйте форму ниже для добавления событий.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add/Edit Event Form -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h3><asp:Literal ID="FormTitleLiteral" runat="server" Text="Добавить новое событие"></asp:Literal></h3>
                    </div>
                    <div class="card-body">
                        <asp:HiddenField ID="EventIdHiddenField" runat="server" />
                        <div class="form-group row mb-3">
                            <label for="TitleTextBox" class="col-sm-2 col-form-label">Название:</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="TitleTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="TitleValidator" runat="server" 
                                    ControlToValidate="TitleTextBox" ErrorMessage="Название обязательно" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <label for="DescriptionTextBox" class="col-sm-2 col-form-label">Описание:</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="DescriptionTextBox" runat="server" CssClass="form-control" 
                                    TextMode="MultiLine" Rows="3"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="DescriptionValidator" runat="server" 
                                    ControlToValidate="DescriptionTextBox" ErrorMessage="Описание обязательно" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <label for="StartDateTextBox" class="col-sm-2 col-form-label">Дата/время начала:</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="StartDateTextBox" runat="server" CssClass="form-control" 
                                    TextMode="DateTimeLocal"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="StartDateValidator" runat="server" 
                                    ControlToValidate="StartDateTextBox" ErrorMessage="Дата начала обязательна" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <label for="EndDateTextBox" class="col-sm-2 col-form-label">Дата/время окончания:</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="EndDateTextBox" runat="server" CssClass="form-control" 
                                    TextMode="DateTimeLocal"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="EndDateValidator" runat="server" 
                                    ControlToValidate="EndDateTextBox" ErrorMessage="Дата окончания обязательна" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="DateCompareValidator" runat="server" 
                                    ControlToValidate="EndDateTextBox"
                                    ClientValidationFunction="ValidateDates"
                                    ErrorMessage="Дата окончания должна быть позже даты начала" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:CustomValidator>
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <label for="LocationTextBox" class="col-sm-2 col-form-label">Место проведения:</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="LocationTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="LocationValidator" runat="server" 
                                    ControlToValidate="LocationTextBox" ErrorMessage="Место проведения обязательно" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <label for="MaxAttendeesTextBox" class="col-sm-2 col-form-label">Макс. количество участников:</label>
                            <div class="col-sm-10">
                                <asp:TextBox ID="MaxAttendeesTextBox" runat="server" CssClass="form-control" 
                                    TextMode="Number" min="1"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="MaxAttendeesValidator" runat="server" 
                                    ControlToValidate="MaxAttendeesTextBox" ErrorMessage="Максимальное количество участников обязательно" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="MaxAttendeesRangeValidator" runat="server" 
                                    ControlToValidate="MaxAttendeesTextBox" Type="Integer" 
                                    MinimumValue="1" MaximumValue="1000" 
                                    ErrorMessage="Введите значение от 1 до 1000" 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="EventForm"></asp:RangeValidator>
                            </div>
                        </div>
                        <div class="form-group row">
                            <div class="col-sm-10 offset-sm-2">
                                <asp:Button ID="SaveButton" runat="server" Text="Сохранить" 
                                    CssClass="btn btn-primary" OnClick="SaveButton_Click" ValidationGroup="EventForm" />
                                <asp:Button ID="CancelButton" runat="server" Text="Отмена" 
                                    CssClass="btn btn-secondary" OnClick="CancelButton_Click" CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Attendees Modal -->
        <div class="modal fade" id="attendeesModal" tabindex="-1" aria-labelledby="attendeesModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-info text-white">
                        <h5 class="modal-title" id="attendeesModalLabel">Список участников</h5>
                    </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <asp:GridView ID="AttendeesGridView" runat="server" CssClass="table table-striped table-hover" 
                                AutoGenerateColumns="false" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID студента" />
                                    <asp:BoundField DataField="Name" HeaderText="Имя" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" />
                                    <asp:BoundField DataField="RegistrationDate" HeaderText="Дата регистрации" DataFormatString="{0:g}" />
                                </Columns>
                                <HeaderStyle CssClass="thead-dark" />
                                <EmptyDataTemplate>
                                    <div class="alert alert-info">Никто не зарегистрирован на это событие.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeAttendeesModal()">Закрыть</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <script type="text/javascript">
        // Function to initialize and display the attendee modal
        function showAttendeesModal() {
            try {
                var modal = document.getElementById('attendeesModal');
                
                // Bootstrap 5 implementation
                if (typeof bootstrap !== 'undefined') {
                    var myModal = new bootstrap.Modal(modal);
                    myModal.show();
                } else {
                    // Fallback if Bootstrap 5 is not available
                    modal.style.display = 'block';
                    modal.classList.add('show');
                    document.body.classList.add('modal-open');
                    
                    // Add backdrop
                    if (!document.querySelector('.modal-backdrop')) {
                        var backdrop = document.createElement('div');
                        backdrop.className = 'modal-backdrop fade show';
                        document.body.appendChild(backdrop);
                    }
                }
            } catch (e) {
                console.error("Error showing modal: " + e);
                // Fallback alert if modal fails
                alert("Не удалось открыть модальное окно. Обновите страницу и попробуйте снова.");
            }
        }
        
        // Function to close the modal
        function closeAttendeesModal() {
            try {
                var modal = document.getElementById('attendeesModal');
                
                if (typeof bootstrap !== 'undefined') {
                    var bsModal = bootstrap.Modal.getInstance(modal);
                    if (bsModal) {
                        bsModal.hide();
                    } else {
                        // If instance not found, create and hide
                        var newModal = new bootstrap.Modal(modal);
                        newModal.hide();
                    }
                } else {
                    // Fallback hiding
                    modal.style.display = 'none';
                    modal.classList.remove('show');
                    document.body.classList.remove('modal-open');
                    
                    // Remove backdrop
                    var backdrop = document.querySelector('.modal-backdrop');
                    if (backdrop) backdrop.parentNode.removeChild(backdrop);
                }
            } catch (e) {
                console.error("Error closing modal: " + e);
                // Manual hide if all else fails
                var modal = document.getElementById('attendeesModal');
                if (modal) {
                    modal.style.display = 'none';
                    modal.classList.remove('show');
                }
                document.body.classList.remove('modal-open');
                var backdrop = document.querySelector('.modal-backdrop');
                if (backdrop) backdrop.parentNode.removeChild(backdrop);
            }
        }
        
        // Initialize Bootstrap components when the DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            // Add click handler to close button
            var closeButton = document.querySelector('.modal-footer .btn-secondary');
            if (closeButton) {
                closeButton.addEventListener('click', closeAttendeesModal);
            }
            
            // Make sure we can detect esc key for closing modals
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    var modal = document.getElementById('attendeesModal');
                    if (modal && modal.classList.contains('show')) {
                        closeAttendeesModal();
                    }
                }
            });
            
            // Add click outside modal handler
            document.addEventListener('click', function(event) {
                var modal = document.getElementById('attendeesModal');
                if (modal && modal.classList.contains('show') && 
                    !modal.contains(event.target) && 
                    !event.target.classList.contains('modal-backdrop')) {
                    closeAttendeesModal();
                }
            });
        });

        function ValidateDates(source, args) {
            try {
                var startDateValue = document.getElementById('<%= StartDateTextBox.ClientID %>').value;
                var endDateValue = args.Value;
                
                if (startDateValue && endDateValue) {
                    var startDate = new Date(startDateValue);
                    var endDate = new Date(endDateValue);
                    
                    args.IsValid = (endDate > startDate);
                } else {
                    args.IsValid = true;
                }
            } catch (e) {
                args.IsValid = false;
            }
        }
    </script>

    <style>
        /* Адаптивность для администраторской панели */
        @media (max-width: 768px) {
            h2 {
                font-size: 1.8rem;
                text-align: center;
            }
            
            p.lead {
                text-align: center;
            }
            
            .card-header h3 {
                font-size: 1.2rem;
            }
            
            .col-sm-2 {
                width: 100%;
                margin-bottom: 0.5rem;
            }
            
            .col-sm-10 {
                width: 100%;
            }
            
            .offset-sm-2 {
                margin-left: 0;
            }
            
            .form-group.row {
                margin-bottom: 1rem !important;
            }
            
            .btn {
                margin-bottom: 0.5rem;
            }
            
            /* Улучшение отображения таблицы для мобильных устройств */
            .table-responsive {
                border: 0;
            }
            
            .table th, .table td {
                font-size: 0.9rem;
                padding: 0.5rem;
            }
            
            /* Адаптация кнопок в таблице */
            .btn-sm {
                margin: 0.2rem;
                padding: 0.25rem 0.4rem;
                font-size: 0.8rem;
            }
        }
        
        /* Стили для очень маленьких экранов */
        @media (max-width: 576px) {
            .card-body {
                padding: 1rem;
            }
            
            h2 {
                font-size: 1.5rem;
            }
            
            .table-responsive {
                white-space: nowrap;
            }
            
            /* Скрываем некоторые колонки на маленьких экранах */
            .table th:nth-child(1), 
            .table td:nth-child(1),
            .table th:nth-child(4), 
            .table td:nth-child(4) {
                display: none;
            }
            
            /* Модальное окно для маленьких экранов */
            .modal-dialog {
                margin: 0.5rem;
                max-width: 95%;
            }
            
            .modal-title {
                font-size: 1.2rem;
            }
        }
    </style>
</asp:Content> 