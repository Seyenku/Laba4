//------------------------------------------------------------------------------
// <������������� �����������>
//     ���� ��� ������ ����������.
//
//     ��������� � ���� ����� ����� �������� � ������������ ������ � ����� �������� � ������
//     ��������� ��������� ����. 
// </������������� �����������>
//------------------------------------------------------------------------------

namespace Laba4
{


    public partial class AdminCalendar
    {

        /// <summary>
        /// EventsGridView ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.GridView EventsGridView;

        /// <summary>
        /// FormTitleLiteral ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Literal FormTitleLiteral;

        /// <summary>
        /// EventIdHiddenField ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.HiddenField EventIdHiddenField;

        /// <summary>
        /// TitleTextBox ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox TitleTextBox;

        /// <summary>
        /// TitleValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator TitleValidator;

        /// <summary>
        /// DescriptionTextBox ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox DescriptionTextBox;

        /// <summary>
        /// DescriptionValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator DescriptionValidator;

        /// <summary>
        /// StartDateTextBox ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox StartDateTextBox;

        /// <summary>
        /// StartDateValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator StartDateValidator;

        /// <summary>
        /// EndDateTextBox ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox EndDateTextBox;

        /// <summary>
        /// EndDateValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator EndDateValidator;

        /// <summary>
        /// DateCompareValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.CustomValidator DateCompareValidator;

        /// <summary>
        /// LocationTextBox ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox LocationTextBox;

        /// <summary>
        /// LocationValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator LocationValidator;

        /// <summary>
        /// MaxAttendeesTextBox ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.TextBox MaxAttendeesTextBox;

        /// <summary>
        /// MaxAttendeesValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RequiredFieldValidator MaxAttendeesValidator;

        /// <summary>
        /// MaxAttendeesRangeValidator ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.RangeValidator MaxAttendeesRangeValidator;

        /// <summary>
        /// SaveButton ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Button SaveButton;

        /// <summary>
        /// CancelButton ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.Button CancelButton;

        /// <summary>
        /// AttendeesGridView ������� ����������.
        /// </summary>
        /// <remarks>
        /// ������������� ��������� ����.
        /// ��� ��������� ����������� ���������� ���� �� ����� ������������ � ���� ���� ����������� �����.
        /// </remarks>
        protected global::System.Web.UI.WebControls.GridView AttendeesGridView;
    }
}
