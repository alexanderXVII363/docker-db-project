# How to Run the Zoo Management System GUI

## Requirements
- Python 3.x installed
- Docker running with the database container
- psycopg2-binary installed

## Step 1 – Install dependency
Open terminal and run:
```
pip3 install psycopg2-binary --break-system-packages
```

## Step 2 – Start Docker
Make sure Docker is running and the containers are up:
```
docker-compose up -d
```

## Step 3 – Run the application
From the Stage5 folder, run:
```
python3 app.py
```

## Step 4 – Login
- Username: `admin`
- Password: `admin`

## Features
- **Dashboard** – overview of all table row counts
- **All 12 tables** – full CRUD (Create, Read, Update, Delete)
- **Queries screen** – run Stage 2 SELECT queries
- **Functions screen** – run Stage 4 functions and procedures
- **Update screen** – enter ID to load record, then edit fields
- **No IDs shown** – foreign keys display names instead of numbers
