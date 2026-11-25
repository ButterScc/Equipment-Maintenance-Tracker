# Industrial Maintenance Management System

<p align="center">
  **A Web-Based Computerized Maintenance Management System (CMMS)**
  
  Manage industrial equipment, monitor maintenance activities, and organize preventive maintenance schedules in one platform.
</p>

<p align="center">
  ![Ruby](https://img.shields.io/badge/Ruby-3.4-red?logo=ruby)
  ![Rails](https://img.shields.io/badge/Rails-8.1.4-red?logo=rubyonrails)
  ![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-blue?logo=postgresql)
  ![Bootstrap](https://img.shields.io/badge/UI-Bootstrap-7952B3?logo=bootstrap)
  ![Status](https://img.shields.io/badge/Status-In%20Development-orange)
</p>

---

## Overview

**Industrial Maintenance Management System** is a web-based application designed to simplify industrial equipment maintenance management.

The system helps users organize equipment records, track maintenance history, schedule preventive maintenance, monitor equipment conditions, and generate maintenance reports.

This project is developed using Ruby on Rails and PostgreSQL, with a focus on practical maintenance workflows and equipment management.

## Features

### Equipment Management
- Create, view, update, and delete equipment records.
- Manage equipment information and identification codes.
- Track equipment operational status.
- Maintain equipment status history.

### Maintenance Management
- Record equipment maintenance activities.
- Manage maintenance history.
- Categorize maintenance types.
- Track technician information and maintenance descriptions.

### Preventive Maintenance
- Set maintenance intervals for equipment.
- Automatically calculate the next maintenance date.
- Manually customize maintenance schedules.
- Track upcoming maintenance schedules.

### Equipment Monitoring
- Monitor equipment status.
- View equipment maintenance information.
- Identify equipment requiring attention.

### Dashboard & Reporting
- View equipment and maintenance summaries.
- Visualize maintenance information through charts.
- Generate maintenance reports.
- Filter reports by date range.
- Export maintenance reports to PDF.

### Maintenance Calendar
- View scheduled maintenance activities.
- Organize maintenance schedules by date.

## Technology Stack

| Technology | Purpose |
|---|---|
| Ruby | Programming Language |
| Ruby on Rails | Backend Framework |
| PostgreSQL | Relational Database |
| Bootstrap 5 | Frontend Styling |
| JavaScript | Interactive Components |
| Chart.js | Data Visualization |

## Application Screenshots

Screenshots of the application will be added here.

| Dashboard | Equipment Management |
|---|---|
| Add dashboard screenshot here | Add equipment screenshot here |

| Maintenance History | Maintenance Report |
|---|---|
| Add maintenance screenshot here | Add report screenshot here |

## Installation & Setup

### Prerequisites

Make sure you have installed:

- Ruby 3.4
- Rails 8.1
- PostgreSQL
- Bundler

### 1. Clone the repository

```bash
git clone https://github.com/ButterScc/industrial-maintenance-management-system.git
```

### 2. Navigate to the project directory

```bash
cd industrial-maintenance-management-system
```

### 3. Install dependencies

```bash
bundle install
```

### 4. Configure the database

Make sure PostgreSQL is running and configure your database credentials in:

```text
config/database.yml
```

### 5. Create and migrate the database

```bash
bin/rails db:create
