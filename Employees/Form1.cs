using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace Employees
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Строка подключения.
        /// </summary>
        private string connectionString = "";
        
        /// <summary>
        /// Показать список сотрудников.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button1_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                try
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ФИО");
                    dt.Columns.Add("Статус");
                    dt.Columns.Add("Отдел");
                    dt.Columns.Add("Должность");
                    dt.Columns.Add("Дата приема");
                    dt.Columns.Add("Дата увольнения");

                    SqlCommand cmd = new SqlCommand("exec Persons_list", conn);



                    using (DbDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {

                                DataRow r = dt.NewRow();
                                string name = reader.GetString(0);
                                string post = reader.GetString(1);
                                string dep = reader.GetString(2);
                                string stat = reader.GetString(3);
                                DateTime start = reader.GetDateTime(4);
                                r["ФИО"] = name;
                                r["Статус"] = stat;
                                r["Отдел"] = dep;
                                r["Должность"] = post;
                                r["Дата приема"] = start;
                                DateTime end;
                                if (!reader.IsDBNull(5))
                                {
                                    end = reader.GetDateTime(5);
                                    r["Дата увольнения"] = end;
                                }
                                dt.Rows.Add(r);
                            }
                        }
                    }
                    dataGridView1.DataSource = dt;
                    dataGridView1.AllowUserToAddRows = false;
                }
                catch (Exception err)
                {
                    MessageBox.Show(
                        err.Message,
                        "Error",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning,
                        MessageBoxDefaultButton.Button1,
                        MessageBoxOptions.DefaultDesktopOnly);
                }

            }
        }
            
        /// <summary>
        /// Фильтр сотрудников.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button2_Click(object sender, EventArgs e)
        {
            int row = 0;
            if (radioButton1.Checked)
                row = 0;
            if (radioButton2.Checked)
                row = 1;
            if (radioButton3.Checked)
                row = 2;
            if (radioButton4.Checked)
                row = 3;
            dataGridView1.CurrentCell = null;
            for (int i = 0; i < dataGridView1.Rows.Count; i++)
                if (row != 0)
                    dataGridView1.Rows[i].Visible = dataGridView1.Rows[i].Visible && dataGridView1[row, i].Value.ToString() == textBox1.Text;
                else
                    dataGridView1.Rows[i].Visible = dataGridView1.Rows[i].Visible && dataGridView1[row, i].Value.ToString().Contains(textBox1.Text);
        }

        /// <summary>
        /// Сброс фильтра.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button3_Click(object sender, EventArgs e)
        {
            dataGridView1.CurrentCell = null;
            for (int i = 0; i < dataGridView1.Rows.Count; i++)
                dataGridView1.Rows[i].Visible = true;
        }

        /// <summary>
        /// Вывод статистики
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void button4_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                try
                {
                    string sql = "";
                    if (radioButton5.Checked)
                        sql = "Persons_employ";
                    else if (radioButton6.Checked)
                        sql = "Persons_unemploy";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    DateTime date_start = dateTimePicker1.Value;
                    DateTime date_end = dateTimePicker2.Value;
                    string status = comboBox1.SelectedItem.ToString();

                    cmd.Parameters.Add("@date_start", SqlDbType.DateTime).Value = date_start;
                    cmd.Parameters.Add("@date_end", SqlDbType.DateTime).Value = date_end;
                    cmd.Parameters.Add("@stat", SqlDbType.VarChar).Value = status;

                    DataTable dt = new DataTable();
                    dt.Columns.Add("Дата");
                    dt.Columns.Add("Количество");

                    using (DbDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                DataRow r = dt.NewRow();
                                DateTime date = reader.GetDateTime(0);
                                Int32 count = reader.GetInt32(1);
                                r["Дата"] = date;
                                r["Количество"] = count;
                                dt.Rows.Add(r);
                            }
                        }
                    }
                    dataGridView2.DataSource = dt;
                    dataGridView2.AllowUserToAddRows = false;
                }
                catch (Exception err)
                {
                    MessageBox.Show(
                        err.Message,
                        "Error",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning,
                        MessageBoxDefaultButton.Button1,
                        MessageBoxOptions.DefaultDesktopOnly);
                }

            }
        }
    }
}
