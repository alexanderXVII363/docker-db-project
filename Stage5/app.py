import tkinter as tk
from tkinter import ttk, messagebox
import psycopg2
from psycopg2 import sql

# ============================================================
# Database Connection
# ============================================================
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "database": "mydb",
    "user": "postgres",
    "password": "admin"
}

def get_connection():
    return psycopg2.connect(**DB_CONFIG)

# ============================================================
# Colors & Styles
# ============================================================
BG_DARK     = "#1e1e2e"
BG_PANEL    = "#2a2a3e"
BG_CARD     = "#313149"
ACCENT      = "#7c6af7"
ACCENT_DARK = "#5a4fd4"
TEXT_LIGHT  = "#e0e0f0"
TEXT_DIM    = "#9090b0"
SUCCESS     = "#4caf88"
DANGER      = "#f06060"
WHITE       = "#ffffff"
FONT_TITLE  = ("Segoe UI", 22, "bold")
FONT_HEAD   = ("Segoe UI", 14, "bold")
FONT_BODY   = ("Segoe UI", 11)
FONT_SMALL  = ("Segoe UI", 9)
FONT_BTN    = ("Segoe UI", 11, "bold")

def styled_button(parent, text, command, color=ACCENT, width=18):
    btn = tk.Button(parent, text=text, command=command,
                    bg=color, fg=WHITE, font=FONT_BTN,
                    relief="flat", cursor="hand2",
                    padx=12, pady=8, width=width)
    btn.bind("<Enter>", lambda e: btn.config(bg=ACCENT_DARK if color==ACCENT else color))
    btn.bind("<Leave>", lambda e: btn.config(bg=color))
    return btn

def styled_label(parent, text, font=FONT_BODY, color=TEXT_LIGHT, anchor="w"):
    return tk.Label(parent, text=text, font=font, bg=BG_PANEL,
                    fg=color, anchor=anchor)

def styled_entry(parent, width=30):
    e = tk.Entry(parent, font=FONT_BODY, bg=BG_CARD, fg=TEXT_LIGHT,
                 insertbackground=TEXT_LIGHT, relief="flat",
                 bd=6, width=width)
    return e

def styled_frame(parent, bg=BG_PANEL):
    return tk.Frame(parent, bg=bg)

# ============================================================
# Main Application
# ============================================================
class ZooApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Zoo Ticket & Visitor Management System")
        self.geometry("1200x750")
        self.configure(bg=BG_DARK)
        self.resizable(True, True)
        self.current_frame = None
        self.show_login()

    def show_frame(self, frame_class, *args):
        if self.current_frame:
            self.current_frame.destroy()
        self.current_frame = frame_class(self, *args)
        self.current_frame.pack(fill="both", expand=True)

    def show_login(self):
        self.show_frame(LoginScreen)

    def show_home(self):
        self.show_frame(HomeScreen)

# ============================================================
# Login Screen
# ============================================================
class LoginScreen(tk.Frame):
    def __init__(self, master):
        super().__init__(master, bg=BG_DARK)
        self.master = master
        self.build()

    def build(self):
        # Center card
        card = tk.Frame(self, bg=BG_PANEL, padx=50, pady=40)
        card.place(relx=0.5, rely=0.5, anchor="center")

        tk.Label(card, text="🦁", font=("Segoe UI", 48), bg=BG_PANEL, fg=ACCENT).pack()
        tk.Label(card, text="Zoo Management System", font=FONT_TITLE,
                 bg=BG_PANEL, fg=TEXT_LIGHT).pack(pady=(0, 5))
        tk.Label(card, text="Please login to continue", font=FONT_BODY,
                 bg=BG_PANEL, fg=TEXT_DIM).pack(pady=(0, 30))

        # Username
        tk.Label(card, text="Username", font=FONT_BODY, bg=BG_PANEL, fg=TEXT_DIM).pack(anchor="w")
        self.user_entry = styled_entry(card, width=35)
        self.user_entry.pack(pady=(2, 15), ipady=6)
        self.user_entry.insert(0, "admin")

        # Password
        tk.Label(card, text="Password", font=FONT_BODY, bg=BG_PANEL, fg=TEXT_DIM).pack(anchor="w")
        self.pass_entry = styled_entry(card, width=35)
        self.pass_entry.config(show="*")
        self.pass_entry.pack(pady=(2, 25), ipady=6)
        self.pass_entry.insert(0, "admin")

        styled_button(card, "Login", self.login, width=35).pack(ipady=4)
        self.err_label = tk.Label(card, text="", font=FONT_SMALL, bg=BG_PANEL, fg=DANGER)
        self.err_label.pack(pady=(10,0))

    def login(self):
        user = self.user_entry.get()
        pwd  = self.pass_entry.get()
        if user == "admin" and pwd == "admin":
            try:
                conn = get_connection()
                conn.close()
                self.master.show_home()
            except Exception as e:
                self.err_label.config(text=f"DB Connection failed: {e}")
        else:
            self.err_label.config(text="Invalid username or password")

# ============================================================
# Home Screen
# ============================================================
class HomeScreen(tk.Frame):
    def __init__(self, master):
        super().__init__(master, bg=BG_DARK)
        self.master = master
        self.build()

    def build(self):
        # Sidebar
        sidebar = tk.Frame(self, bg=BG_PANEL, width=220)
        sidebar.pack(side="left", fill="y")
        sidebar.pack_propagate(False)

        tk.Label(sidebar, text="🦁 Zoo System", font=FONT_HEAD,
                 bg=BG_PANEL, fg=ACCENT).pack(pady=(25,5))
        tk.Label(sidebar, text="Management Portal", font=FONT_SMALL,
                 bg=BG_PANEL, fg=TEXT_DIM).pack(pady=(0,25))

        ttk.Separator(sidebar, orient="horizontal").pack(fill="x", padx=15)

        nav_items = [
            ("🏠  Dashboard",     self.show_dashboard),
            ("👤  Visitors",      lambda: self.show_table("visitors")),
            ("👨‍💼  Employees",     lambda: self.show_table("employees")),
            ("🎟️  Ticket Types",  lambda: self.show_table("ticket_types")),
            ("💳  Transactions",  lambda: self.show_table("transactions")),
            ("🧾  Trans. Items",  lambda: self.show_table("transaction_items")),
            ("🏅  Memberships",   lambda: self.show_table("memberships")),
            ("👔  Managers",      lambda: self.show_table("manager")),
            ("📁  Projects",      lambda: self.show_table("project")),
            ("📋  Tasks",         lambda: self.show_table("task")),
            ("📊  Reports",       lambda: self.show_table("report")),
            ("📈  KPIs",          lambda: self.show_table("kpi")),
            ("🔍  Audit",         lambda: self.show_table("audit")),
            ("⚡  Queries",       self.show_queries),
            ("⚙️  Functions",     self.show_functions),
        ]

        for text, cmd in nav_items:
            btn = tk.Button(sidebar, text=text, command=cmd,
                            bg=BG_PANEL, fg=TEXT_LIGHT, font=FONT_BODY,
                            relief="flat", anchor="w", padx=20, pady=8,
                            cursor="hand2", width=22)
            btn.bind("<Enter>", lambda e, b=btn: b.config(bg=BG_CARD))
            btn.bind("<Leave>", lambda e, b=btn: b.config(bg=BG_PANEL))
            btn.pack(fill="x")

        ttk.Separator(sidebar, orient="horizontal").pack(fill="x", padx=15, pady=10)
        tk.Button(sidebar, text="🚪  Logout", command=self.master.show_login,
                  bg=BG_PANEL, fg=DANGER, font=FONT_BODY,
                  relief="flat", anchor="w", padx=20, pady=8,
                  cursor="hand2", width=22).pack(fill="x")

        # Main content area
        self.content = tk.Frame(self, bg=BG_DARK)
        self.content.pack(side="right", fill="both", expand=True)

        self.show_dashboard()

    def clear_content(self):
        for w in self.content.winfo_children():
            w.destroy()

    def show_dashboard(self):
        self.clear_content()
        DashboardPanel(self.content).pack(fill="both", expand=True)

    def show_table(self, table):
        self.clear_content()
        TablePanel(self.content, table).pack(fill="both", expand=True)

    def show_queries(self):
        self.clear_content()
        QueriesPanel(self.content).pack(fill="both", expand=True)

    def show_functions(self):
        self.clear_content()
        FunctionsPanel(self.content).pack(fill="both", expand=True)

# ============================================================
# Dashboard Panel
# ============================================================
class DashboardPanel(tk.Frame):
    def __init__(self, master):
        super().__init__(master, bg=BG_DARK)
        self.build()

    def build(self):
        tk.Label(self, text="Dashboard", font=FONT_TITLE,
                 bg=BG_DARK, fg=TEXT_LIGHT).pack(anchor="w", padx=30, pady=(25,5))
        tk.Label(self, text="System overview", font=FONT_BODY,
                 bg=BG_DARK, fg=TEXT_DIM).pack(anchor="w", padx=30, pady=(0,20))

        cards_frame = tk.Frame(self, bg=BG_DARK)
        cards_frame.pack(fill="x", padx=30)

        tables = [
            ("👤 Visitors",      "SELECT COUNT(*) FROM visitors"),
            ("👨‍💼 Employees",     "SELECT COUNT(*) FROM employees"),
            ("💳 Transactions",  "SELECT COUNT(*) FROM transactions"),
            ("🎟️ Ticket Types",  "SELECT COUNT(*) FROM ticket_types"),
            ("🏅 Memberships",   "SELECT COUNT(*) FROM memberships"),
            ("👔 Managers",      "SELECT COUNT(*) FROM manager"),
        ]

        try:
            conn = get_connection()
            cur = conn.cursor()
            for i, (label, query) in enumerate(tables):
                cur.execute(query)
                count = cur.fetchone()[0]
                card = tk.Frame(cards_frame, bg=BG_CARD, padx=20, pady=15)
                card.grid(row=i//3, column=i%3, padx=10, pady=10, sticky="ew")
                cards_frame.columnconfigure(i%3, weight=1)
                tk.Label(card, text=label, font=FONT_BODY, bg=BG_CARD, fg=TEXT_DIM).pack(anchor="w")
                tk.Label(card, text=str(count), font=("Segoe UI", 28, "bold"),
                         bg=BG_CARD, fg=ACCENT).pack(anchor="w")
            cur.close()
            conn.close()
        except Exception as e:
            tk.Label(self, text=f"Error loading dashboard: {e}",
                     bg=BG_DARK, fg=DANGER, font=FONT_BODY).pack(pady=20)

# ============================================================
# Table Panel (CRUD for all tables)
# ============================================================
TABLE_CONFIG = {
    "visitors": {
        "display_query": """
            SELECT visitor_id, first_name, last_name, phone, email,
                   date_of_birth, registration_date, loyalty_points
            FROM visitors ORDER BY visitor_id
        """,
        "columns": ["ID","First Name","Last Name","Phone","Email","DOB","Reg. Date","Loyalty Pts"],
        "pk": "visitor_id",
        "insert_fields": ["first_name","last_name","phone","email","date_of_birth","registration_date"],
        "insert_sql": "INSERT INTO visitors (visitor_id, first_name, last_name, phone, email, date_of_birth, registration_date) VALUES ((SELECT COALESCE(MAX(visitor_id),0)+1 FROM visitors), %s, %s, %s, %s, %s, %s)",
        "update_fields": ["first_name","last_name","phone","email"],
        "update_sql": "UPDATE visitors SET first_name=%s, last_name=%s, phone=%s, email=%s WHERE visitor_id=%s",
        "delete_sql": "DELETE FROM visitors WHERE visitor_id=%s",
        "fetch_sql": "SELECT first_name, last_name, phone, email FROM visitors WHERE visitor_id=%s",
    },
    "employees": {
        "display_query": """
            SELECT e.employee_id, e.first_name, e.last_name, e.hire_date,
                   COALESCE(m.first_name||' '||m.last_name,'No Manager') AS manager,
                   e.bonus_amount
            FROM employees e LEFT JOIN manager m ON e.manager_id=m.manager_id
            ORDER BY e.employee_id
        """,
        "columns": ["ID","First Name","Last Name","Hire Date","Manager","Bonus"],
        "pk": "employee_id",
        "insert_fields": ["first_name","last_name","hire_date"],
        "insert_sql": "INSERT INTO employees (employee_id, first_name, last_name, hire_date) VALUES ((SELECT COALESCE(MAX(employee_id),0)+1 FROM employees), %s, %s, %s)",
        "update_fields": ["first_name","last_name","hire_date"],
        "update_sql": "UPDATE employees SET first_name=%s, last_name=%s, hire_date=%s WHERE employee_id=%s",
        "delete_sql": "DELETE FROM employees WHERE employee_id=%s",
        "fetch_sql": "SELECT first_name, last_name, hire_date FROM employees WHERE employee_id=%s",
    },
    "ticket_types": {
        "display_query": "SELECT ticket_id, ticket_name, category, base_price, max_capacity FROM ticket_types ORDER BY ticket_id",
        "columns": ["ID","Ticket Name","Category","Base Price","Max Capacity"],
        "pk": "ticket_id",
        "insert_fields": ["ticket_name","category","base_price","max_capacity"],
        "insert_sql": "INSERT INTO ticket_types (ticket_id, ticket_name, category, base_price, max_capacity) VALUES ((SELECT COALESCE(MAX(ticket_id),0)+1 FROM ticket_types), %s, %s, %s, %s)",
        "update_fields": ["ticket_name","category","base_price","max_capacity"],
        "update_sql": "UPDATE ticket_types SET ticket_name=%s, category=%s, base_price=%s, max_capacity=%s WHERE ticket_id=%s",
        "delete_sql": "DELETE FROM ticket_types WHERE ticket_id=%s",
        "fetch_sql": "SELECT ticket_name, category, base_price, max_capacity FROM ticket_types WHERE ticket_id=%s",
    },
    "transactions": {
        "display_query": """
            SELECT t.transaction_id,
                   v.first_name||' '||v.last_name AS visitor,
                   e.first_name||' '||e.last_name AS employee,
                   t.transaction_date, t.total_amount, t.payment_method
            FROM transactions t
            JOIN visitors v ON t.visitor_id=v.visitor_id
            JOIN employees e ON t.employee_id=e.employee_id
            ORDER BY t.transaction_id DESC LIMIT 200
        """,
        "columns": ["ID","Visitor","Employee","Date","Amount","Payment"],
        "pk": "transaction_id",
        "insert_fields": ["visitor_id","employee_id","transaction_date","total_amount","payment_method"],
        "insert_sql": "INSERT INTO transactions (transaction_id, visitor_id, employee_id, transaction_date, total_amount, payment_method) VALUES ((SELECT COALESCE(MAX(transaction_id),0)+1 FROM transactions), %s, %s, %s, %s, %s)",
        "update_fields": ["total_amount","payment_method"],
        "update_sql": "UPDATE transactions SET total_amount=%s, payment_method=%s WHERE transaction_id=%s",
        "delete_sql": "DELETE FROM transactions WHERE transaction_id=%s",
        "fetch_sql": "SELECT total_amount, payment_method FROM transactions WHERE transaction_id=%s",
    },
    "transaction_items": {
        "display_query": """
            SELECT ti.item_id, ti.transaction_id,
                   tt.ticket_name, ti.quantity, ti.price_at_sale
            FROM transaction_items ti
            JOIN ticket_types tt ON ti.ticket_id=tt.ticket_id
            ORDER BY ti.transaction_id DESC LIMIT 200
        """,
        "columns": ["Item ID","Transaction ID","Ticket","Quantity","Price at Sale"],
        "pk": "item_id",
        "insert_fields": ["transaction_id","ticket_id","quantity","price_at_sale"],
        "insert_sql": "INSERT INTO transaction_items (item_id, transaction_id, ticket_id, quantity, price_at_sale) VALUES ((SELECT COALESCE(MAX(item_id),0)+1 FROM transaction_items), %s, %s, %s, %s)",
        "update_fields": ["quantity","price_at_sale"],
        "update_sql": "UPDATE transaction_items SET quantity=%s, price_at_sale=%s WHERE item_id=%s",
        "delete_sql": "DELETE FROM transaction_items WHERE item_id=%s",
        "fetch_sql": "SELECT quantity, price_at_sale FROM transaction_items WHERE item_id=%s",
    },
    "memberships": {
        "display_query": """
            SELECT m.membership_id,
                   v.first_name||' '||v.last_name AS visitor,
                   m.start_date, m.expiry_date, m.is_active
            FROM memberships m
            JOIN visitors v ON m.visitor_id=v.visitor_id
            ORDER BY m.membership_id
        """,
        "columns": ["ID","Visitor","Start Date","Expiry Date","Active"],
        "pk": "membership_id",
        "insert_fields": ["visitor_id","start_date","expiry_date"],
        "insert_sql": "INSERT INTO memberships (membership_id, visitor_id, start_date, expiry_date) VALUES ((SELECT COALESCE(MAX(membership_id),0)+1 FROM memberships), %s, %s, %s)",
        "update_fields": ["start_date","expiry_date","is_active"],
        "update_sql": "UPDATE memberships SET start_date=%s, expiry_date=%s, is_active=%s WHERE membership_id=%s",
        "delete_sql": "DELETE FROM memberships WHERE membership_id=%s",
        "fetch_sql": "SELECT start_date, expiry_date, is_active FROM memberships WHERE membership_id=%s",
    },
    "manager": {
        "display_query": "SELECT manager_id, first_name, last_name, email, phone, seniority_level, hire_date FROM manager ORDER BY manager_id",
        "columns": ["ID","First Name","Last Name","Email","Phone","Seniority","Hire Date"],
        "pk": "manager_id",
        "insert_fields": ["first_name","last_name","email","phone","seniority_level","hire_date"],
        "insert_sql": "INSERT INTO manager (manager_id, first_name, last_name, email, phone, seniority_level, hire_date) VALUES ((SELECT COALESCE(MAX(manager_id),0)+1 FROM manager), %s, %s, %s, %s, %s, %s)",
        "update_fields": ["first_name","last_name","email","phone","seniority_level"],
        "update_sql": "UPDATE manager SET first_name=%s, last_name=%s, email=%s, phone=%s, seniority_level=%s WHERE manager_id=%s",
        "delete_sql": "DELETE FROM manager WHERE manager_id=%s",
        "fetch_sql": "SELECT first_name, last_name, email, phone, seniority_level FROM manager WHERE manager_id=%s",
    },
    "project": {
        "display_query": """
            SELECT p.project_id, p.project_name, p.status, p.budget,
                   p.start_date, p.end_date,
                   m.first_name||' '||m.last_name AS manager
            FROM project p JOIN manager m ON p.manager_id=m.manager_id
            ORDER BY p.project_id
        """,
        "columns": ["ID","Project Name","Status","Budget","Start","End","Manager"],
        "pk": "project_id",
        "insert_fields": ["project_name","description","start_date","end_date","budget","status","manager_id"],
        "insert_sql": "INSERT INTO project (project_id, project_name, description, start_date, end_date, budget, status, manager_id) VALUES ((SELECT COALESCE(MAX(project_id),0)+1 FROM project), %s, %s, %s, %s, %s, %s, %s)",
        "update_fields": ["project_name","status","budget"],
        "update_sql": "UPDATE project SET project_name=%s, status=%s, budget=%s WHERE project_id=%s",
        "delete_sql": "DELETE FROM project WHERE project_id=%s",
        "fetch_sql": "SELECT project_name, status, budget FROM project WHERE project_id=%s",
    },
    "task": {
        "display_query": """
            SELECT t.task_id, t.task_name, t.priority, t.status, t.due_date,
                   p.project_name
            FROM task t JOIN project p ON t.project_id=p.project_id
            ORDER BY t.task_id
        """,
        "columns": ["ID","Task Name","Priority","Status","Due Date","Project"],
        "pk": "task_id",
        "insert_fields": ["task_name","description","due_date","priority","status","project_id"],
        "insert_sql": "INSERT INTO task (task_id, task_name, description, due_date, priority, status, project_id) VALUES ((SELECT COALESCE(MAX(task_id),0)+1 FROM task), %s, %s, %s, %s, %s, %s)",
        "update_fields": ["task_name","priority","status","due_date"],
        "update_sql": "UPDATE task SET task_name=%s, priority=%s, status=%s, due_date=%s WHERE task_id=%s",
        "delete_sql": "DELETE FROM task WHERE task_id=%s",
        "fetch_sql": "SELECT task_name, priority, status, due_date FROM task WHERE task_id=%s",
    },
    "report": {
        "display_query": """
            SELECT r.report_id, r.report_name, r.report_type, r.report_date,
                   r.department_name,
                   m.first_name||' '||m.last_name AS manager
            FROM report r JOIN manager m ON r.manager_id=m.manager_id
            ORDER BY r.report_id
        """,
        "columns": ["ID","Report Name","Type","Date","Department","Manager"],
        "pk": "report_id",
        "insert_fields": ["report_name","report_date","department_name","report_type","summary","manager_id"],
        "insert_sql": "INSERT INTO report (report_id, report_name, report_date, department_name, report_type, summary, manager_id) VALUES ((SELECT COALESCE(MAX(report_id),0)+1 FROM report), %s, %s, %s, %s, %s, %s)",
        "update_fields": ["report_name","report_type","department_name"],
        "update_sql": "UPDATE report SET report_name=%s, report_type=%s, department_name=%s WHERE report_id=%s",
        "delete_sql": "DELETE FROM report WHERE report_id=%s",
        "fetch_sql": "SELECT report_name, report_type, department_name FROM report WHERE report_id=%s",
    },
    "kpi": {
        "display_query": """
            SELECT k.kpi_id, k.kpi_name, k.department_name,
                   k.target_value, k.actual_value, k.unit,
                   p.project_name
            FROM kpi k JOIN project p ON k.project_id=p.project_id
            ORDER BY k.kpi_id
        """,
        "columns": ["ID","KPI Name","Department","Target","Actual","Unit","Project"],
        "pk": "kpi_id",
        "insert_fields": ["kpi_name","department_name","target_value","actual_value","measurement_date","unit","project_id"],
        "insert_sql": "INSERT INTO kpi (kpi_id, kpi_name, department_name, target_value, actual_value, measurement_date, unit, project_id) VALUES ((SELECT COALESCE(MAX(kpi_id),0)+1 FROM kpi), %s, %s, %s, %s, %s, %s, %s)",
        "update_fields": ["kpi_name","target_value","actual_value"],
        "update_sql": "UPDATE kpi SET kpi_name=%s, target_value=%s, actual_value=%s WHERE kpi_id=%s",
        "delete_sql": "DELETE FROM kpi WHERE kpi_id=%s",
        "fetch_sql": "SELECT kpi_name, target_value, actual_value FROM kpi WHERE kpi_id=%s",
    },
    "audit": {
        "display_query": """
            SELECT a.audit_id, a.department_name, a.finding,
                   a.severity, a.status, a.audit_date,
                   m.first_name||' '||m.last_name AS manager,
                   p.project_name
            FROM audit a
            JOIN manager m ON a.manager_id=m.manager_id
            JOIN project p ON a.project_id=p.project_id
            ORDER BY a.audit_id
        """,
        "columns": ["ID","Department","Finding","Severity","Status","Date","Manager","Project"],
        "pk": "audit_id",
        "insert_fields": ["audit_date","department_name","finding","severity","status","manager_id","project_id"],
        "insert_sql": "INSERT INTO audit (audit_id, audit_date, department_name, finding, severity, status, manager_id, project_id) VALUES ((SELECT COALESCE(MAX(audit_id),0)+1 FROM audit), %s, %s, %s, %s, %s, %s, %s)",
        "update_fields": ["finding","severity","status"],
        "update_sql": "UPDATE audit SET finding=%s, severity=%s, status=%s WHERE audit_id=%s",
        "delete_sql": "DELETE FROM audit WHERE audit_id=%s",
        "fetch_sql": "SELECT finding, severity, status FROM audit WHERE audit_id=%s",
    },
}

class TablePanel(tk.Frame):
    def __init__(self, master, table):
        super().__init__(master, bg=BG_DARK)
        self.table = table
        self.config_data = TABLE_CONFIG[table]
        self.build()

    def build(self):
        # Header
        header = tk.Frame(self, bg=BG_DARK)
        header.pack(fill="x", padx=30, pady=(20,10))
        tk.Label(header, text=self.table.replace("_"," ").title(),
                 font=FONT_TITLE, bg=BG_DARK, fg=TEXT_LIGHT).pack(side="left")

        # Action buttons
        btn_frame = tk.Frame(self, bg=BG_DARK)
        btn_frame.pack(fill="x", padx=30, pady=(0,10))
        styled_button(btn_frame, "➕ Insert", self.show_insert, width=14).pack(side="left", padx=(0,8))
        styled_button(btn_frame, "✏️ Update", self.show_update, color="#5a9fd4", width=14).pack(side="left", padx=(0,8))
        styled_button(btn_frame, "🗑️ Delete", self.show_delete, color=DANGER, width=14).pack(side="left", padx=(0,8))
        styled_button(btn_frame, "🔄 Refresh", self.load_data, color=SUCCESS, width=14).pack(side="left")

        # Table
        table_frame = tk.Frame(self, bg=BG_DARK)
        table_frame.pack(fill="both", expand=True, padx=30, pady=(0,10))

        cols = self.config_data["columns"]
        self.tree = ttk.Treeview(table_frame, columns=cols, show="headings", height=18)

        style = ttk.Style()
        style.theme_use("default")
        style.configure("Treeview", background=BG_CARD, foreground=TEXT_LIGHT,
                        fieldbackground=BG_CARD, rowheight=28, font=FONT_BODY)
        style.configure("Treeview.Heading", background=BG_PANEL, foreground=ACCENT,
                        font=FONT_BODY, relief="flat")
        style.map("Treeview", background=[("selected", ACCENT)])

        for col in cols:
            self.tree.heading(col, text=col)
            self.tree.column(col, width=120, anchor="center")

        vsb = ttk.Scrollbar(table_frame, orient="vertical", command=self.tree.yview)
        hsb = ttk.Scrollbar(table_frame, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)

        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        hsb.grid(row=1, column=0, sticky="ew")
        table_frame.grid_rowconfigure(0, weight=1)
        table_frame.grid_columnconfigure(0, weight=1)

        self.status = tk.Label(self, text="", font=FONT_SMALL, bg=BG_DARK, fg=TEXT_DIM)
        self.status.pack(anchor="w", padx=30)

        self.load_data()

    def load_data(self):
        for row in self.tree.get_children():
            self.tree.delete(row)
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute(self.config_data["display_query"])
            rows = cur.fetchall()
            for row in rows:
                self.tree.insert("", "end", values=row)
            self.status.config(text=f"Showing {len(rows)} records", fg=TEXT_DIM)
            cur.close()
            conn.close()
        except Exception as e:
            self.status.config(text=f"Error: {e}", fg=DANGER)

    def show_insert(self):
        win = tk.Toplevel(self)
        win.title(f"Insert into {self.table}")
        win.configure(bg=BG_PANEL)
        win.geometry("400x500")
        tk.Label(win, text=f"Insert New Record", font=FONT_HEAD,
                 bg=BG_PANEL, fg=TEXT_LIGHT).pack(pady=15)
        fields = self.config_data["insert_fields"]
        entries = {}
        for f in fields:
            tk.Label(win, text=f.replace("_"," ").title(), font=FONT_BODY,
                     bg=BG_PANEL, fg=TEXT_DIM).pack(anchor="w", padx=20)
            e = styled_entry(win, width=40)
            e.pack(padx=20, pady=(2,10), ipady=4)
            entries[f] = e

        def do_insert():
            vals = [entries[f].get() for f in fields]
            try:
                conn = get_connection()
                cur = conn.cursor()
                cur.execute(self.config_data["insert_sql"], vals)
                conn.commit()
                cur.close()
                conn.close()
                messagebox.showinfo("Success", "Record inserted successfully!")
                win.destroy()
                self.load_data()
            except Exception as e:
                messagebox.showerror("Error", str(e))

        styled_button(win, "Insert Record", do_insert, width=20).pack(pady=15)

    def show_update(self):
        win = tk.Toplevel(self)
        win.title(f"Update {self.table}")
        win.configure(bg=BG_PANEL)
        win.geometry("400x550")
        tk.Label(win, text="Update Record", font=FONT_HEAD,
                 bg=BG_PANEL, fg=TEXT_LIGHT).pack(pady=15)
        tk.Label(win, text=f"Enter {self.config_data['pk']}:", font=FONT_BODY,
                 bg=BG_PANEL, fg=TEXT_DIM).pack(anchor="w", padx=20)
        pk_entry = styled_entry(win, width=40)
        pk_entry.pack(padx=20, pady=(2,10), ipady=4)
        fields = self.config_data["update_fields"]
        entries = {}
        for f in fields:
            tk.Label(win, text=f.replace("_"," ").title(), font=FONT_BODY,
                     bg=BG_PANEL, fg=TEXT_DIM).pack(anchor="w", padx=20)
            e = styled_entry(win, width=40)
            e.pack(padx=20, pady=(2,8), ipady=4)
            entries[f] = e

        def load_record():
            pk = pk_entry.get()
            try:
                conn = get_connection()
                cur = conn.cursor()
                cur.execute(self.config_data["fetch_sql"], (pk,))
                row = cur.fetchone()
                cur.close()
                conn.close()
                if row:
                    for i, f in enumerate(fields):
                        entries[f].delete(0, tk.END)
                        entries[f].insert(0, str(row[i]) if row[i] is not None else "")
                else:
                    messagebox.showwarning("Not Found", f"No record with ID {pk}")
            except Exception as e:
                messagebox.showerror("Error", str(e))

        styled_button(win, "Load Record", load_record, color=SUCCESS, width=20).pack(pady=5)

        def do_update():
            pk = pk_entry.get()
            vals = [entries[f].get() for f in fields] + [pk]
            try:
                conn = get_connection()
                cur = conn.cursor()
                cur.execute(self.config_data["update_sql"], vals)
                conn.commit()
                cur.close()
                conn.close()
                messagebox.showinfo("Success", "Record updated successfully!")
                win.destroy()
                self.load_data()
            except Exception as e:
                messagebox.showerror("Error", str(e))

        styled_button(win, "Save Update", do_update, width=20).pack(pady=5)

    def show_delete(self):
        win = tk.Toplevel(self)
        win.title(f"Delete from {self.table}")
        win.configure(bg=BG_PANEL)
        win.geometry("350x200")
        tk.Label(win, text="Delete Record", font=FONT_HEAD,
                 bg=BG_PANEL, fg=TEXT_LIGHT).pack(pady=15)
        tk.Label(win, text=f"Enter {self.config_data['pk']} to delete:",
                 font=FONT_BODY, bg=BG_PANEL, fg=TEXT_DIM).pack(anchor="w", padx=20)
        pk_entry = styled_entry(win, width=40)
        pk_entry.pack(padx=20, pady=(2,15), ipady=4)

        def do_delete():
            pk = pk_entry.get()
            if messagebox.askyesno("Confirm", f"Delete record with ID {pk}?"):
                try:
                    conn = get_connection()
                    cur = conn.cursor()
                    cur.execute(self.config_data["delete_sql"], (pk,))
                    conn.commit()
                    cur.close()
                    conn.close()
                    messagebox.showinfo("Success", "Record deleted successfully!")
                    win.destroy()
                    self.load_data()
                except Exception as e:
                    messagebox.showerror("Error", str(e))

        styled_button(win, "Delete Record", do_delete, color=DANGER, width=20).pack()

# ============================================================
# Queries Panel
# ============================================================
QUERIES = {
    "Q1 – Visitors & Transaction Count (JOIN)": """
        SELECT v.visitor_id, v.first_name, v.last_name,
               COUNT(tr.transaction_id) AS total_transactions
        FROM visitors v
        JOIN transactions tr ON v.visitor_id = tr.visitor_id
        GROUP BY v.visitor_id, v.first_name, v.last_name
        ORDER BY total_transactions DESC
        LIMIT 20
    """,
    "Q7 – Average Transactions Per Visitor": """
        SELECT ROUND(AVG(transaction_count), 2) AS avg_transactions_per_visitor
        FROM (
            SELECT visitor_id, COUNT(*) AS transaction_count
            FROM transactions
            GROUP BY visitor_id
        ) sub
    """,
    "Q8 – Visitors With More Than 5 Transactions (HAVING)": """
        SELECT v.visitor_id, v.first_name, v.last_name,
               COUNT(tr.transaction_id) AS total_transactions
        FROM visitors v
        JOIN transactions tr ON v.visitor_id = tr.visitor_id
        GROUP BY v.visitor_id, v.first_name, v.last_name
        HAVING COUNT(tr.transaction_id) > 5
        ORDER BY total_transactions DESC
        LIMIT 20
    """,
    "Q3 – Transactions in Last 30 Days": """
        SELECT transaction_id, visitor_id, transaction_date,
               total_amount, payment_method
        FROM transactions
        WHERE transaction_date >= CURRENT_DATE - INTERVAL '30 days'
        ORDER BY transaction_date DESC
        LIMIT 20
    """,
}

class QueriesPanel(tk.Frame):
    def __init__(self, master):
        super().__init__(master, bg=BG_DARK)
        self.build()

    def build(self):
        tk.Label(self, text="Run Queries", font=FONT_TITLE,
                 bg=BG_DARK, fg=TEXT_LIGHT).pack(anchor="w", padx=30, pady=(20,5))
        tk.Label(self, text="Select and run Stage 2 queries", font=FONT_BODY,
                 bg=BG_DARK, fg=TEXT_DIM).pack(anchor="w", padx=30, pady=(0,15))

        top = tk.Frame(self, bg=BG_DARK)
        top.pack(fill="x", padx=30, pady=(0,10))

        tk.Label(top, text="Select Query:", font=FONT_BODY,
                 bg=BG_DARK, fg=TEXT_DIM).pack(side="left", padx=(0,10))
        self.query_var = tk.StringVar()
        query_names = list(QUERIES.keys())
        self.query_var.set(query_names[0])
        cb = ttk.Combobox(top, textvariable=self.query_var,
                          values=query_names, width=55, font=FONT_BODY)
        cb.pack(side="left", padx=(0,10))
        styled_button(top, "▶ Run Query", self.run_query, width=14).pack(side="left")

        # Results
        result_frame = tk.Frame(self, bg=BG_DARK)
        result_frame.pack(fill="both", expand=True, padx=30, pady=10)

        self.result_tree = ttk.Treeview(result_frame, show="headings", height=20)
        vsb = ttk.Scrollbar(result_frame, orient="vertical", command=self.result_tree.yview)
        hsb = ttk.Scrollbar(result_frame, orient="horizontal", command=self.result_tree.xview)
        self.result_tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)
        self.result_tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        hsb.grid(row=1, column=0, sticky="ew")
        result_frame.grid_rowconfigure(0, weight=1)
        result_frame.grid_columnconfigure(0, weight=1)

        self.status = tk.Label(self, text="", font=FONT_SMALL, bg=BG_DARK, fg=TEXT_DIM)
        self.status.pack(anchor="w", padx=30)

    def run_query(self):
        query = QUERIES[self.query_var.get()]
        for col in self.result_tree["columns"]:
            self.result_tree.heading(col, text="")
        for row in self.result_tree.get_children():
            self.result_tree.delete(row)
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute(query)
            rows = cur.fetchall()
            cols = [desc[0] for desc in cur.description]
            cur.close()
            conn.close()
            self.result_tree["columns"] = cols
            for col in cols:
                self.result_tree.heading(col, text=col.replace("_"," ").title())
                self.result_tree.column(col, width=150, anchor="center")
            for row in rows:
                self.result_tree.insert("", "end", values=row)
            self.status.config(text=f"Returned {len(rows)} rows", fg=SUCCESS)
        except Exception as e:
            self.status.config(text=f"Error: {e}", fg=DANGER)

# ============================================================
# Functions & Procedures Panel
# ============================================================
class FunctionsPanel(tk.Frame):
    def __init__(self, master):
        super().__init__(master, bg=BG_DARK)
        self.build()

    def build(self):
        tk.Label(self, text="Functions & Procedures", font=FONT_TITLE,
                 bg=BG_DARK, fg=TEXT_LIGHT).pack(anchor="w", padx=30, pady=(20,5))
        tk.Label(self, text="Run Stage 4 programs from here", font=FONT_BODY,
                 bg=BG_DARK, fg=TEXT_DIM).pack(anchor="w", padx=30, pady=(0,15))

        cards = tk.Frame(self, bg=BG_DARK)
        cards.pack(fill="x", padx=30)

        # Card 1: get_visitor_summary
        c1 = tk.Frame(cards, bg=BG_CARD, padx=20, pady=20)
        c1.grid(row=0, column=0, padx=10, pady=10, sticky="ew")
        cards.columnconfigure(0, weight=1)
        tk.Label(c1, text="🔍 get_visitor_summary", font=FONT_HEAD,
                 bg=BG_CARD, fg=ACCENT).pack(anchor="w")
        tk.Label(c1, text="Returns full summary for a visitor by ID",
                 font=FONT_SMALL, bg=BG_CARD, fg=TEXT_DIM).pack(anchor="w", pady=(2,10))
        input_frame1 = tk.Frame(c1, bg=BG_CARD)
        input_frame1.pack(anchor="w")
        tk.Label(input_frame1, text="Visitor ID:", font=FONT_BODY,
                 bg=BG_CARD, fg=TEXT_DIM).pack(side="left", padx=(0,5))
        self.vis_id_entry = styled_entry(input_frame1, width=10)
        self.vis_id_entry.pack(side="left", padx=(0,10), ipady=4)
        self.vis_id_entry.insert(0, "1")
        styled_button(input_frame1, "Run", self.run_visitor_summary, width=8).pack(side="left")

        self.vis_result = tk.Label(c1, text="", font=FONT_BODY,
                                   bg=BG_CARD, fg=SUCCESS, justify="left")
        self.vis_result.pack(anchor="w", pady=(10,0))

        # Card 2: update_employee_bonuses
        c2 = tk.Frame(cards, bg=BG_CARD, padx=20, pady=20)
        c2.grid(row=0, column=1, padx=10, pady=10, sticky="ew")
        cards.columnconfigure(1, weight=1)
        tk.Label(c2, text="💰 update_employee_bonuses", font=FONT_HEAD,
                 bg=BG_CARD, fg=ACCENT).pack(anchor="w")
        tk.Label(c2, text="Updates bonus for all employees based on revenue",
                 font=FONT_SMALL, bg=BG_CARD, fg=TEXT_DIM).pack(anchor="w", pady=(2,10))
        styled_button(c2, "▶ Run Procedure", self.run_update_bonuses, width=20).pack(anchor="w")
        self.bonus_result = tk.Label(c2, text="", font=FONT_BODY,
                                     bg=BG_CARD, fg=SUCCESS, justify="left")
        self.bonus_result.pack(anchor="w", pady=(10,0))

        # Card 3: expire_old_memberships
        c3 = tk.Frame(cards, bg=BG_CARD, padx=20, pady=20)
        c3.grid(row=1, column=0, padx=10, pady=10, sticky="ew")
        tk.Label(c3, text="📋 expire_old_memberships", font=FONT_HEAD,
                 bg=BG_CARD, fg=ACCENT).pack(anchor="w")
        tk.Label(c3, text="Expires memberships past their expiry date",
                 font=FONT_SMALL, bg=BG_CARD, fg=TEXT_DIM).pack(anchor="w", pady=(2,10))
        styled_button(c3, "▶ Run Procedure", self.run_expire_memberships, width=20).pack(anchor="w")
        self.expire_result = tk.Label(c3, text="", font=FONT_BODY,
                                      bg=BG_CARD, fg=SUCCESS, justify="left")
        self.expire_result.pack(anchor="w", pady=(10,0))

        # Card 4: get_employee_report
        c4 = tk.Frame(cards, bg=BG_CARD, padx=20, pady=20)
        c4.grid(row=1, column=1, padx=10, pady=10, sticky="ew")
        tk.Label(c4, text="📊 get_employee_report", font=FONT_HEAD,
                 bg=BG_CARD, fg=ACCENT).pack(anchor="w")
        tk.Label(c4, text="Returns full employee performance report",
                 font=FONT_SMALL, bg=BG_CARD, fg=TEXT_DIM).pack(anchor="w", pady=(2,10))
        styled_button(c4, "▶ Run Function", self.run_employee_report, width=20).pack(anchor="w")
        self.report_result = tk.Label(c4, text="", font=FONT_BODY,
                                      bg=BG_CARD, fg=SUCCESS, justify="left")
        self.report_result.pack(anchor="w", pady=(10,0))

    def run_visitor_summary(self):
        vid = self.vis_id_entry.get()
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("SELECT * FROM get_visitor_summary(%s)", (vid,))
            row = cur.fetchone()
            cur.close()
            conn.close()
            if row:
                self.vis_result.config(
                    text=f"Name: {row[0]}\nTransactions: {row[1]}\nTotal Spent: ${row[2]}\nLoyalty Points: {row[3]}\nMembership: {row[4]}",
                    fg=SUCCESS)
            else:
                self.vis_result.config(text="No data found", fg=DANGER)
        except Exception as e:
            self.vis_result.config(text=f"Error: {e}", fg=DANGER)

    def run_update_bonuses(self):
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("CALL update_employee_bonuses()")
            conn.commit()
            cur.execute("SELECT COUNT(*) FROM employees WHERE bonus_amount > 0")
            count = cur.fetchone()[0]
            cur.close()
            conn.close()
            self.bonus_result.config(
                text=f"✅ Done! {count} employees received bonuses.", fg=SUCCESS)
        except Exception as e:
            self.bonus_result.config(text=f"Error: {e}", fg=DANGER)

    def run_expire_memberships(self):
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("CALL expire_old_memberships()")
            conn.commit()
            cur.execute("SELECT COUNT(*) FROM memberships WHERE is_active = FALSE")
            count = cur.fetchone()[0]
            cur.close()
            conn.close()
            self.expire_result.config(
                text=f"✅ Done! {count} memberships are now inactive.", fg=SUCCESS)
        except Exception as e:
            self.expire_result.config(text=f"Error: {e}", fg=DANGER)

    def run_employee_report(self):
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("BEGIN")
            cur.execute("SELECT get_employee_report()")
            cur.execute("FETCH ALL FROM employee_report_cursor")
            rows = cur.fetchall()
            conn.commit()
            cur.close()
            conn.close()
            if rows:
                top3 = rows[:3]
                text = "Top 3 employees by revenue:\n"
                for r in top3:
                    text += f"• {r[1]}: ${r[5]:,.2f} ({r[7]})\n"
                self.report_result.config(text=text, fg=SUCCESS)
        except Exception as e:
            self.report_result.config(text=f"Error: {e}", fg=DANGER)

# ============================================================
# Run App
# ============================================================
if __name__ == "__main__":
    app = ZooApp()
    app.mainloop()
