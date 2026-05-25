import random
from datetime import date, timedelta

payment_methods = ['Credit Card', 'Cash', 'Debit Card', 'PayPal']

with open('transactions_20000.sql', 'w') as f:
    for i in range(1, 20001):
        random_days = random.randint(0, 1826)
        d = date(2020, 1, 1) + timedelta(days=random_days)
        amount = round(random.uniform(10, 500), 2)
        payment = random.choice(payment_methods)
        employee_id = random.randint(1, 500)
        visitor_id = random.randint(1, 500)
        f.write(f"INSERT INTO transactions (transaction_id, transaction_date, total_amount, payment_method, employee_id, visitor_id) VALUES ({i}, '{d}', {amount}, '{payment}', {employee_id}, {visitor_id});\n")

print("transactions_20000.sql done!")

with open('transaction_items_20000.sql', 'w') as f:
    for i in range(1, 20001):
        transaction_id = random.randint(1, 20000)
        ticket_id = random.randint(1, 500)
        quantity = random.randint(1, 10)
        price = round(random.uniform(10, 500), 2)
        f.write(f"INSERT INTO transaction_items (item_id, transaction_id, ticket_id, quantity, price_at_sale) VALUES ({i}, {transaction_id}, {ticket_id}, {quantity}, {price});\n")

print("transaction_items_20000.sql done!")