<%@ Page Title="Регистрация" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Laba4.Register" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <h2><%: Title %></h2>
                <p class="lead">Создайте новую учетную запись для доступа к календарю событий.</p>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6 offset-md-3">
                <div class="card">
                    <div class="card-header">
                        <h3>Форма регистрации</h3>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="SuccessPanel" runat="server" Visible="false" CssClass="alert alert-success">
                            <asp:Literal ID="SuccessMessageLiteral" runat="server"></asp:Literal>
                        </asp:Panel>
                        
                        <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger">
                            <asp:Literal ID="ErrorMessageLiteral" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="form-group row mb-3">
                            <label for="UsernameTextBox" class="col-sm-3 col-form-label">Имя пользователя:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="UsernameTextBox" runat="server" CssClass="form-control" placeholder="Введите имя пользователя"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="UsernameValidator" runat="server" 
                                    ControlToValidate="UsernameTextBox" ErrorMessage="Имя пользователя обязательно" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="UsernameRegexValidator" runat="server"
                                    ControlToValidate="UsernameTextBox" ValidationExpression="^[a-zA-Z0-9_-]{3,20}$"
                                    ErrorMessage="Имя пользователя должно содержать от 3 до 20 символов латинского алфавита, цифры и знаки _ -"
                                    CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        
                        <div class="form-group row mb-3">
                            <label for="FullNameTextBox" class="col-sm-3 col-form-label">ФИО:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="FullNameTextBox" runat="server" CssClass="form-control" placeholder="Введите полное имя"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="FullNameValidator" runat="server" 
                                    ControlToValidate="FullNameTextBox" ErrorMessage="ФИО обязательно" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        
                        <div class="form-group row mb-3">
                            <label for="StudentIdTextBox" class="col-sm-3 col-form-label">Студенческий ID:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="StudentIdTextBox" runat="server" CssClass="form-control" placeholder="Введите студенческий ID"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="StudentIdValidator" runat="server" 
                                    ControlToValidate="StudentIdTextBox" ErrorMessage="Студенческий ID обязателен" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        
                        <div class="form-group row mb-3">
                            <label for="EmailTextBox" class="col-sm-3 col-form-label">Email:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" placeholder="Введите email" TextMode="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="EmailValidator" runat="server" 
                                    ControlToValidate="EmailTextBox" ErrorMessage="Email обязателен" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="EmailRegexValidator" runat="server"
                                    ControlToValidate="EmailTextBox" ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                    ErrorMessage="Введите корректный email адрес"
                                    CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        
                        <div class="form-group row mb-3">
                            <label for="PasswordTextBox" class="col-sm-3 col-form-label">Пароль:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="form-control" placeholder="Введите пароль"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="PasswordValidator" runat="server" 
                                    ControlToValidate="PasswordTextBox" ErrorMessage="Пароль обязателен" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="PasswordRegexValidator" runat="server"
                                    ControlToValidate="PasswordTextBox" ValidationExpression="^.{6,}$"
                                    ErrorMessage="Пароль должен содержать минимум 6 символов"
                                    CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                        </div>
                        
                        <div class="form-group row mb-3">
                            <label for="ConfirmPasswordTextBox" class="col-sm-3 col-form-label">Подтверждение пароля:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="ConfirmPasswordTextBox" runat="server" TextMode="Password" CssClass="form-control" placeholder="Повторите пароль"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="ConfirmPasswordValidator" runat="server" 
                                    ControlToValidate="ConfirmPasswordTextBox" ErrorMessage="Подтверждение пароля обязательно" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="PasswordCompareValidator" runat="server"
                                    ControlToValidate="ConfirmPasswordTextBox" ControlToCompare="PasswordTextBox"
                                    ErrorMessage="Пароли не совпадают"
                                    CssClass="text-danger" Display="Dynamic"></asp:CompareValidator>
                            </div>
                        </div>
                        
                        <div class="form-group row">
                            <div class="col-sm-9 offset-sm-3">
                                <asp:Button ID="RegisterButton" runat="server" Text="Зарегистрироваться" 
                                    CssClass="btn btn-primary" OnClick="RegisterButton_Click" />
                                <a href="Login.aspx" class="btn btn-outline-secondary ms-2">Вернуться к входу</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <style>
        /* Адаптивность для мобильных устройств */
        @media (max-width: 768px) {
            .col-sm-3 {
                text-align: left;
                margin-bottom: 0.5rem;
            }
            
            .offset-sm-3 {
                margin-left: 0;
            }
            
            .form-group.row {
                margin-bottom: 1rem !important;
            }
            
            .btn {
                display: block;
                width: 100%;
                margin-bottom: 0.5rem;
            }
            
            .btn + .btn, 
            .btn + a.btn {
                margin-left: 0 !important;
            }
            
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
            
            .text-danger {
                font-size: 0.9rem;
            }
        }
        
        /* Стили для очень маленьких экранов */
        @media (max-width: 576px) {
            .col-md-6.offset-md-3 {
                padding-left: 5px;
                padding-right: 5px;
            }
            
            .card-body {
                padding: 1rem;
            }
            
            h2 {
                font-size: 1.5rem;
            }
            
            .col-sm-3,
            .col-sm-9 {
                padding-left: 0.5rem;
                padding-right: 0.5rem;
            }
            
            /* Уменьшаем размер текста длинных сообщений валидации */
            .text-danger {
                font-size: 0.8rem;
            }
        }
    </style>
</asp:Content> 