<%@ Page Title="Вход в систему" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Laba4.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <h2><%: Title %></h2>
                <p class="lead">Войдите в систему, используя свои учетные данные.</p>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6 offset-md-3">
                <div class="card">
                    <div class="card-header">
                        <h3>Форма входа</h3>
                    </div>
                    <div class="card-body">
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
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <label for="PasswordTextBox" class="col-sm-3 col-form-label">Пароль:</label>
                            <div class="col-sm-9">
                                <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" CssClass="form-control" placeholder="Введите пароль"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="PasswordValidator" runat="server" 
                                    ControlToValidate="PasswordTextBox" ErrorMessage="Пароль обязателен" 
                                    CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group row mb-3">
                            <div class="col-sm-9 offset-sm-3">
                                <asp:CheckBox ID="RememberMeCheckBox" runat="server" Text="Запомнить меня" />
                            </div>
                        </div>
                        <div class="form-group row">
                            <div class="col-sm-9 offset-sm-3">
                                <asp:Button ID="LoginButton" runat="server" Text="Войти" 
                                    CssClass="btn btn-primary" OnClick="LoginButton_Click" />
                                <a href="Register.aspx" class="btn btn-outline-primary ms-2">Регистрация</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card mt-4">
                    <div class="card-header">
                        <h5>Тестовые учетные данные</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <strong>Администратор:</strong>
                            <ul>
                                <li>Логин: admin</li>
                                <li>Пароль: admin123</li>
                            </ul>
                        </div>
                        <div>
                            <strong>Студент:</strong>
                            <ul>
                                <li>Логин: student</li>
                                <li>Пароль: student123</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content> 