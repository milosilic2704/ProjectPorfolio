# BelFor Power BI Semantic Model - As-Built Documentation

**Project Name:** BelFor Business Intelligence Reporting System  
**Model Name:** BelFor Semantic Model  
**Version:** 1.0 (Current Production)  
**Last Updated:** October 2025  
**Developer/Team:** BI Development Team  
**Business Owner:** Finance Department  

---

## 📋 Table of Contents

1. [Executive Overview](#executive-overview)
2. [Solution Architecture](#solution-architecture)
3. [Data Sources](#data-sources)
4. [Data Transformation & Loading](#data-transformation--loading)
5. [Data Model Design](#data-model-design)
6. [Measures & Calculations](#measures--calculations)
7. [Calculated Columns](#calculated-columns)
8. [Refresh Schedule](#refresh-schedule)
9. [Security & Access](#security--access)
10. [Known Limitations](#known-limitations)

---

## 📊 Executive Overview

### Purpose
The BelFor Power BI semantic model provides comprehensive business intelligence reporting across financial, operational, and project management data. It consolidates data from Business Central ERP, MongoDB case management system, and SharePoint-hosted budget files to provide unified reporting capabilities.

### Scope
The model covers:
- **Financial reporting:** Revenue, costs, budgets, variance analysis
- **Project management:** Job tracking, WIP (work in progress), invoicing
- **Time tracking:** Employee hours, utilization, absence
- **Organizational analytics:** Department, region, and resource analysis

### Key Users
- Finance team (budget and actual analysis)
- Department managers (operational metrics)
- Project managers (job profitability and progress)
- Executive leadership (high-level KPIs)

### Data Volume
- **Historical data:** From January 2022 onwards
- **Fact table rows:** Approximately 500,000+ transactions
- **Dimension tables:** ~20,000 rows combined
- **Refresh frequency:** Daily (overnight)

---

## 🏗️ Solution Architecture

### Technology Stack
- **Platform:** Power BI Service (Premium Capacity)
- **Development Tool:** Power BI Desktop
- **Data Sources:**
  - Microsoft SQL Server (Business Central database)
  - Power Platform Dataflows (Business Central entities)
  - SharePoint Online (budget and mapping files)
  - MongoDB (via Dataflows - case management)

### Data Flow
```
[Business Central SQL] ─────┐
[Power Platform Dataflows] ─┼──> [Power Query M] ──> [Import Model] ──> [Power BI Service]
[SharePoint Files] ─────────┘
```

### Model Type
**Import Mode** - All data is imported and stored in the semantic model for optimal query performance.

---

## 📂 Data Sources

### 1. Business Central - SQL Database
**Connection:** Direct SQL Server connection  
**Server:** ssg-sql06  
**Database:** BC180PROD  
**Authentication:** Windows Authentication / Service Account  

**Tables Used:**
- Job Ledger Entry (project transactions)
- Job (project master data)
- G/L Entry (financial ledger)
- Resource (employees and contractors)
- Customer (customer master)
- Dimension Set Entry (organizational dimensions)

**Refresh Method:** Full refresh daily

---

### 2. Power Platform Dataflows
**Workspace:** 3e0e0353-ee74-497d-90f8-459670338d30  
**Dataflow:** f5e29494-2891-45d8-aadf-e4807be01bca  

**Entities Used:**
- bc Resource_system (resource details with custom fields)
- G_L Account (chart of accounts)
- Mongo Cases (case management data)
- Mongo Categories (damage categories)
- Mongo Causes (damage causes)
- Mongo Location (location master)
- Mongo Departments (department structure)

**Refresh Method:** Dataflow refreshes independently, model imports from dataflow

---

### 3. SharePoint Online
**Site:** https://ssgcloud.sharepoint.com/sites/DK-PowerBIData/  
**Library:** Data Business Central  

**Files Used:**
- `/PBI data source/new budger to power bi static.xlsx` (Budget data)
- `/PBI data source/Mapping Tables.xlsx` (Document mappings)
- `/PBI data source/Open Balance 2022_2023.xlsx` (Opening balances)
- `/PBI data source/Manuelt.xlsx` (Manual adjustments)
- `/PBI_Azure filer/BelforCalandar.xlsx` (Custom calendar)
- `/PBI_driftsfiler/Rapport_faktureret.xlsx` (Revenue targets)

**Refresh Method:** Files are accessed directly during refresh

---

## 🔄 Data Transformation & Loading

### Query Organization
Queries are organized into three groups:
1. **Helper Tables** - Supporting queries and intermediate transformations
2. **Dim Tables** - Dimension tables for star schema
3. **Fact_Tables** - Fact tables containing transactions and measures

---

## 📊 DIMENSION TABLES

### Dim_Afdeling (Departments)
**Source:** Power Platform Dataflows → bc Global_Dimensions  
**Purpose:** Department and region organizational structure  

**Transformation Steps:**
1. Connect to Dataflow entity
2. Filter to Global Dimension Code 1
3. Remove duplicate dimension values
4. Rename columns to Danish names:
   - Dimension Value Code → Afdelingsnr
   - Dimension Value Name → Afdelingsnavn2
5. Add Region mapping based on department number

**Key Columns:**
- `Afdelingsnr` (INT) - Department number (primary key)
- `Afdelingsnavn2` (TEXT) - Department name
- `Regionsnavn` (TEXT) - Region name

**Row Count:** ~50 departments

---

### Dim_Kalender (Calendar)
**Source:** SharePoint → BelforCalandar.xlsx + Power Query date functions  
**Purpose:** Date dimension with custom Belfor periods  

**Transformation Steps:**
1. Load calendar file from SharePoint
2. Connect to external calendar CSV via web source
3. Merge calendars based on posting date
4. Add standard date attributes (Day, Month, Quarter, Year)
5. Calculate custom Belfor period numbers (1-12 per year)
6. Add relative date calculations:
   - Days from today
   - Months from today (Belfor periods from today)
   - Weeks from today
7. Create Year-Period composite key
8. Calculate first day in each period
9. Rename columns to Danish names

**Key Columns:**
- `Posteringsdato` (DATE) - Posting date (primary key)
- `År` (INT) - Year
- `Måned` (TEXT) - Month number
- `Month Name` (TEXT) - Month name
- `Week Number` (TEXT) - ISO week number
- `Quarter Name` (TEXT) - Quarter (Q1-Q4)
- `Periode_Nummer` (INT) - Belfor period number (1-12)
- `Periode_Navn` (TEXT) - Belfor period name
- `Year-Period` (TEXT) - Composite key for period
- `BelforPeriodefraidag` (INT) - Periods from today
- `First Day in Period` (DATE) - First date in Belfor period

**Row Count:** ~2,000 dates (covering 2020-2027)

**Business Logic:**
- Belfor periods align with monthly accounting periods but with custom start dates
- Period calculations enable rolling 12-period analysis
- "Periods from today" enables dynamic filtering (last 3 periods, etc.)

---

### Dim_Konto (Account Master)
**Source:** Power Platform Dataflows → G_L Account  
**Purpose:** General ledger account master data  

**Transformation Steps:**
1. Connect to Dataflow G_L Account entity
2. Rename columns to Danish:
   - No_ → Kontonummer
   - Name → Kontonavn
3. Filter out accounts starting with "W" (work accounts)
4. Remove specific system-modified timestamp
5. Create composite column: Kontonummer/Kontonavn
6. Remove unused columns (Account_Type, Account_Category, Totaling)

**Key Columns:**
- `Kontonummer` (TEXT) - Account number (primary key)
- `Kontonavn` (TEXT) - Account name
- `Kontonummer/Kontonavn` (TEXT) - Combined display field
- `_systemÆndretDen` (TEXT) - System modified timestamp

**Row Count:** ~500 accounts

---

### Dim_Kontoplan (Chart of Accounts with Hierarchy)
**Source:** SharePoint → Mapping Tables.xlsx  
**Purpose:** Account hierarchy for financial reporting  

**Transformation Steps:**
1. Load from SharePoint Excel file
2. Select relevant columns for hierarchy
3. Transform column types
4. Filter out null account numbers
5. Rename columns to Danish:
   - Level 3 → Niveau_3
   - Level3_Sort → Niveau3_Sort
   - New expense → Ny_udgift
   - Level 2 sort → Niveau_2_sortering
   - Level 2.1 sort → Niveau_2.1_sortering

**Key Columns:**
- `Konto` (TEXT) - Account number (primary key)
- `Ny_udgift` (INT) - Expense/Income indicator (-1 or 1)
- `Niveau_3` (TEXT) - Level 3 category
- `Niveau3_Sort` (INT) - Level 3 sort order
- `Niveau_3_visning` (TEXT) - Level 3 display name
- `Niveau_3_fremhævning` (INT) - Level 3 highlight flag
- `Niveau_2_sortering` (TEXT) - Level 2 category
- `Niveau_2.1_sortering` (INT) - Level 2.1 sort order

**Row Count:** ~500 accounts with hierarchy

**Business Logic:**
- Three-level hierarchy for P&L reporting
- Level 2 categories: Omsætning, IGVA, D-Personale, D-Underleverandør, etc.
- Level 3 provides detailed breakdown
- `Ny_udgift` flag determines if income (negative sign) or expense (positive sign)

---

### Dim_Resource (Resources/Employees)
**Source:** Power Platform Dataflows → bc Resource_system  
**Purpose:** Employee and contractor master data  

**Transformation Steps:**
1. Connect to Dataflow bc Resource_system entity
2. Select relevant resource columns
3. Rename custom fields:
   - RIT_E_Mail → E_Mail
   - RIT_Mobile_Phone_No_ → Mobile_Phone
4. Keep standard Business Central fields

**Key Columns:**
- `No_` (TEXT) - Resource number (primary key)
- `Type` (TEXT) - Resource type
- `Name` (TEXT) - Resource name
- `Job_Title` (TEXT) - Job title
- `Employment_Date` (DATE) - Employment start date
- `Resource Group No_` (TEXT) - Resource group
- `Global Dimension 1 Code` (INT) - Department number
- `E_Mail` (TEXT) - Email address
- `Mobile_Phone` (TEXT) - Mobile phone
- `Lessor_Payment_Type` (INT) - Payment type (0=internal, 3=contractor)
- `Blocked` (TEXT) - Blocked flag
- `Termination_Date` (DATE) - Termination date

**Row Count:** ~200 resources

---

### Dim_Job (Job/Project Master)
**Source:** SQL Server → BC180PROD → SSG A_S$Job  
**Purpose:** Project/job master data with status and attributes  

**Transformation Steps:**
1. Connect to SQL Server Job table
2. Select relevant job fields
3. Add creation date period mapping (merge with Dim_Kalender)
4. Add 5C closing date period mapping (merge with Dim_Kalender)
5. Calculate creation date as date type (was datetime)
6. Merge with Mongo Cases for additional attributes
7. Create custom Status NEW field with business rules
8. Remove duplicates based on Job Number

**Key Columns:**
- `Nr` (TEXT) - Job number (primary key)
- `Faktureringskunde_Nr` (TEXT) - Billing customer number
- `Creation Date` (DATE) - Job creation date
- `Startdato` (DATE) - Start date
- `Slutdato` (DATE) - End date
- `Status` (TEXT) - Job status
- `Status NEW` (TEXT) - Calculated status field
- `Navn` (TEXT) - Job name
- `Faktureringsnavn` (TEXT) - Billing name
- `Kundeopslaggruppe` (TEXT) - Customer posting group
- `Afdelings Nr` (INT) - Department number
- `Person Responsible` (TEXT) - Responsible person
- `Creation Period` (TEXT) - Period when created
- `5C Closing Period` (TEXT) - Period when 5C closed
- `Creation_BelforPeriodefraidag` (INT) - Periods since creation
- `5C Closing_BelforPeriodefraidag` (INT) - Periods since 5C closing
- `Cause Name` (TEXT) - Cause from MongoDB
- `Categories Name` (TEXT) - Category from MongoDB

**Row Count:** ~10,000 jobs

**Business Logic:**
- Status NEW combines BC status with custom business rules
- Creation and closing periods enable cohort analysis
- MongoDB attributes enriched for case analysis

---

### Dim_Customer (Customer Master)
**Source:** SQL Server → BC180PROD → SSG A_S$Customer  
**Purpose:** Customer master data  

**Transformation Steps:**
1. Connect to SQL Server Customer table
2. Select No_ and Customer Posting Group columns only

**Key Columns:**
- `No_` (TEXT) - Customer number (primary key)
- `Customer Posting Group` (TEXT) - Posting group

**Row Count:** ~2,000 customers

---

### Dim_Sag (Cases from MongoDB)
**Source:** Power Platform Dataflows → Mongo Cases  
**Purpose:** Extended case information from MongoDB system  

**Transformation Steps:**
1. Connect to Dataflow Mongo Cases
2. Merge with Mongo Categories (damage categories)
3. Merge with Mongo Causes (damage causes)
4. Merge with Mongo Location (locations)
5. Merge with Mongo Department (department info)
6. Select relevant case fields
7. Create Job_Link field

**Key Columns:**
- `id_$oid` (TEXT) - MongoDB ObjectID (primary key)
- `Created Date` (DATE) - Case creation date
- `Updated Date` (DATE) - Last update date
- `Status` (TEXT) - Case status
- `Debitor ERP No` (TEXT) - Customer number in ERP
- `Company` (TEXT) - Company name
- `Categories Name` (TEXT) - Damage category
- `Cause Name` (TEXT) - Damage cause
- `Description` (TEXT) - Case description
- `Damage Contact Address/City/Country` (TEXT) - Damage location
- `Policy Holder Name/Address/City` (TEXT) - Policy holder info
- `Project Manager` (TEXT) - Project manager name
- `Case Manager` (TEXT) - Case manager name
- `Location Name` (TEXT) - SSG location
- `Department Name/Number/Manager` (TEXT) - Department info
- `Job_Link` (TEXT) - Link to ERP job

**Row Count:** ~8,000 cases

---

## 📈 FACT TABLES

### Fact_Job (Job Ledger Entries)
**Source:** SQL Server → BC180PROD → SSG A_S$Job Ledger Entry  
**Purpose:** All project transactions (time, materials, costs, invoicing)  

**Transformation Steps:**
1. Connect to SQL Server Job Ledger Entry table
2. Select relevant transaction columns
3. Add custom calculated columns using Record expansion:
   - **Invoiced:** If Source Code = "SALG" then -Total Price (LCY), else null
   - **Sales:** If Source Code = "SALG" or "IGVA_KORR" then 0, else Total Price (LCY)
   - **Cost:** If Source Code = "SALG" or "IGVA_KORR" then 0, else Total Cost (LCY)
4. Expand calculated columns to table level
5. Transform column types (dates, numbers)
6. Add Month column from Posting Date
7. Merge with Dim_Afdeling (department info)
8. Merge with Dim_Job_1 helper (for WIP fields)
9. Merge with Dim_Job (for Afdelings Nr)
10. Add Task Code Grouping logic:
    - Map Job Task No_ to task categories using lookup table
    - Categories: Absense Sick, Absense Holiday, Internal Meeting, Internal Adm, etc.
11. Rename all columns to Danish names

**Key Columns:**
- `Job_Nr` (TEXT) - Job number
- `Global Dimension 1 Code` (INT) - Department
- `Posteringsdato` (DATE) - Posting date
- `Dokument_Nr` (TEXT) - Document number
- `Line Amount` (DECIMAL) - Line amount
- `Type` (INT) - Type (0=Resource, 1=Item, 2=G/L)
- `Nr` (TEXT) - Number
- `Beskrivelse` (TEXT) - Description
- `Source Code` (TEXT) - Source code
- `Mængde` (DECIMAL) - Quantity (hours)
- `Enhedsomkostning (LCY)` (DECIMAL) - Unit cost
- `Samlede_Omkostninger (LCY)` (DECIMAL) - Total cost
- `Enhedspris (LCY)` (DECIMAL) - Unit price
- `Samlet_pris (LCY)` (DECIMAL) - Total price
- `Arbejdstypekode` (TEXT) - Work type code
- `Faktureret` (DECIMAL) - Invoiced amount (calculated)
- `Salg` (DECIMAL) - Sales amount (calculated)
- `Omkostning` (DECIMAL) - Cost amount (calculated)
- `Måned` (INT) - Month number
- `Afdelingsnavn2` (TEXT) - Department name
- `Regionsnavn` (TEXT) - Region name
- `RIT Cost Estimate` (DECIMAL) - Cost estimate
- `RIT WIP Limit` (DECIMAL) - WIP limit
- `Task Code grouping` (TEXT) - Task category (calculated)

**Row Count:** ~450,000 transactions

**Business Logic:**
- **Invoiced field:** Captures actual invoicing (Source Code = "SALG") with negative sign reversed
- **Sales/Cost separation:** SALG and IGVA_KORR transactions don't contribute to sales/cost metrics
- **Task Code Grouping:** Maps 40+ task codes to ~10 categories for reporting
  - Absense categories: Sick, Sick+, Maternity, Holiday
  - Internal categories: Course, Meeting, Customer Visits, Admin
  - Flex and On-call categories
  - Defaults to "Other" if not mapped
- **WIP fields enriched:** Cost Estimate and WIP Limit pulled from Job master

---

### Fact_Finans (Financial Ledger)
**Source:** Multiple sources combined  
**Purpose:** General ledger financial postings  

**Transformation Steps:**
1. **Source 1 - Dataflow G/L Entries:**
   - Connect to Power Platform Dataflows
   - Load bc G_L Entry entity
   - Select core columns
   - Add "Source data" = "BC" marker

2. **Source 2 - Opening Balances (SharePoint):**
   - Load Open Balance 2022_2023.xlsx from SharePoint
   - Select: Posting Date, Document No, G/L Account No, Amount, Description
   - Rename columns to match Source 1
   - Add "Source data" = "Open B" marker

3. **Source 3 - Manual Postings (SharePoint):**
   - Load Manuelt.xlsx from SharePoint
   - Select same columns as Source 2
   - Rename to match
   - Add "Source data" = "Manual" marker

4. **Append all sources together**

5. **Add mappings:**
   - Merge with Data helper table (document number mapping)
   - Merge with Dim_Job (billing name and customer group)
   - Merge with Dim_Dimension_Set (registration number)

6. **Transform columns and rename to Danish:**
   - G_L Account No_ → G_L_Kontonummer
   - Posting Date → Posteringsdato
   - Document Type → Dokumenttype
   - Amount → Beløb
   - Global Dimension 1 Code → Global_Dimension_1_Kode
   - Source Code → Kildekode
   - Job No_ → Jobnummer
   - Dimension Set ID → Dimension_Sæt_ID

**Key Columns:**
- `G_L_Kontonummer` (TEXT) - G/L account number
- `Posteringsdato` (DATE) - Posting date
- `Dokumenttype` (INT) - Document type (2=Invoice, 3=Credit)
- `Dokumentnummer` (TEXT) - Document number
- `Beskrivelse` (TEXT) - Description
- `Beløb` (DECIMAL) - Amount
- `Global_Dimension_1_Kode` (INT) - Department
- `Kildekode` (TEXT) - Source code
- `Jobnummer` (TEXT) - Job number
- `Eksternt_Dokumentnummer` (TEXT) - External document number
- `Dimension_Sæt_ID` (INT) - Dimension set ID
- `Kildedata` (TEXT) - Source data indicator
- `Faktureringsnavn` (TEXT) - Billing name (from Job)
- `Kundeopslaggruppe` (TEXT) - Customer posting group (from Job)
- `Registreringsnummer` (TEXT) - Registration number (from Dimension)
- `Filtrer_Dokumentnummer` (TEXT) - Filter document number (from mapping)

**Row Count:** ~300,000 entries

**Business Logic:**
- Combines three data sources for complete financial picture
- Opening balances loaded for historical data
- Manual postings allow corrections and adjustments
- Document mapping enables filtering and grouping

---

### Fact_Budget (Budget Data)
**Source:** SharePoint → new budger to power bi static.xlsx  
**Purpose:** Annual budget by department and account  

**Transformation Steps:**
1. Load Excel file from SharePoint
2. Select Budget sheet
3. Promote headers
4. Remove unnecessary columns
5. Filter to valid budget entries
6. Rename columns to Danish:
   - Entry No. → Indgan_ Nr
   - Budget Name → Budget_Navn
   - G/L Account No. → G_L_Kontonummer
   - Date → Dato
   - Amount → Beløb

**Key Columns:**
- `Global Dimension 1 Code` (INT) - Department
- `Indgan_ Nr` (TEXT) - Entry number
- `Budget_Navn` (TEXT) - Budget name
- `G_L_Kontonummer` (TEXT) - G/L account number
- `Dato` (DATE) - Date
- `Beløb` (DECIMAL) - Budget amount
- `Posteringsdato` (DATE) - Posting date (for calendar link)

**Row Count:** ~8,000 budget lines

**Business Logic:**
- Budget_Navn ending in "DKB" indicates main DK budget
- One budget line per account per month
- Amounts in local currency (DKK)

---

### Fact_Job_Planning (Job Planning Lines)
**Source:** SQL Server → BC180PROD → SSG A_S$Job Planning Line  
**Purpose:** Quote and planning lines for jobs  

**Transformation Steps:**
1. Connect to SQL Server
2. Navigate to BC180PROD database
3. Filter to Job Planning Line table
4. Select columns: Job No_, No_, Planning Date, Total Price
5. Filter to specific account numbers (quotes/screening):
   - 1000, 1005, 1009, 1010, 1015, 1019, 1025, 1030, 1040, 1050, 1065, 1100, 1105, 1109
6. Transform No_ column to integer

**Key Columns:**
- `Job No_` (TEXT) - Job number
- `No_` (INT) - Account number
- `Planning Date` (DATE) - Planning date
- `Total Price` (DECIMAL) - Total price

**Row Count:** ~15,000 planning lines

**Business Logic:**
- Only planning lines for specific quote/screening accounts
- Used to track sales pipeline and initial assessments
- Total Price represents potential revenue

---

### Fact_Jobcount (Job Count Tracking)
**Source:** SQL Server → BC180PROD → SSG A_S$Job  
**Purpose:** Track job counts by creation date and responsible person  

**Transformation Steps:**
1. Connect to SQL Server Job table
2. Select: No_, Creation Date, Person Responsible, Global Dimension 1 Code
3. Transform Creation Date to date type
4. Rename columns to Danish:
   - No_ → Job Nr
   - Person Responsible → Person Ansvalig
   - Global Dimension 1 Code → Afdelings Nr
5. Remove blank rows
6. Transform Afdelings Nr to integer

**Key Columns:**
- `Job Nr` (TEXT) - Job number
- `Creation Date` (DATE) - Creation date
- `Person Ansvalig` (TEXT) - Responsible person
- `Afdelings Nr` (INT) - Department number

**Row Count:** ~10,000 jobs

**Business Logic:**
- Tracks when jobs were created for trend analysis
- Links to responsible person for accountability
- Used for job creation metrics and workload analysis

---

### Fact_Mål_BR_Faktureret (Revenue Targets)
**Source:** SharePoint → Rapport_faktureret.xlsx  
**Purpose:** Department revenue targets and status  

**Transformation Steps:**
1. Load Excel file from SharePoint
2. Import specific sheet
3. Promote headers
4. Select relevant columns:
   - Global Dimension Code 1
   - Måltal TDKK (Target in thousands)
   - Deadline
   - Status
5. Transform column types (date, integer)

**Key Columns:**
- `Global Dimension Code 1` (INT) - Department
- `Måltal TDKK` (INT) - Target in thousands DKK
- `Deadline` (DATE) - Target deadline
- `Status` (TEXT) - Status

**Row Count:** ~50 targets

**Business Logic:**
- One target per department
- Måltal TDKK is the revenue target for the period
- Status tracks achievement (On Track, At Risk, etc.)

---

## 🔗 Data Model Design

### Model Type
**Star Schema** - Optimized for reporting and analysis

### Schema Structure
```
         Dim_Kalender ──────┬────────┬────────┬─────────┬──────────┐
         Dim_Afdeling ──────┼────┬───┼────┬───┼────┬────┼────┬─────┤
         Dim_Resource ──────┤    │   │    │   │    │    │    │     │
         Dim_Job ───────────┼────┼───┼────┼───┼────┤    │    │     │
         Dim_Konto ─────────┤    │   │    │   │    │    │    │     │
         Dim_Kontoplan ─────┤    │   │    │   │    │    │    │     │
                            │    │   │    │   │    │    │    │     │
                       Fact_Job  │   │    │   │    │    │    │     │
                    Fact_Jobcount│   │    │   │    │    │    │     │
                        Fact_Finans   │    │   │    │    │    │     │
                           Fact_Budget│   │    │    │    │    │     │
                     Fact_Job_Planning   │    │    │    │    │     │
                                    Fact_Mål_BR_Faktureret    │     │
                                                               │     │
                                                        @Measures    │
                                                   (Calculation Table)
```

---

## 📊 RELATIONSHIPS

All relationships are **One-to-Many** from Dimension to Fact, with **Single Direction** cross-filtering.

### Dim_Kalender Relationships
| From Table | From Column | To Table | To Column | Type |
|------------|-------------|----------|-----------|------|
| Dim_Kalender | Posteringsdato | Fact_Job | Posteringsdato | One-to-Many |
| Dim_Kalender | Posteringsdato | Fact_Finans | Posteringsdato | One-to-Many |
| Dim_Kalender | Posteringsdato | Fact_Budget | Posteringsdato | One-to-Many |
| Dim_Kalender | Posteringsdato | Fact_Jobcount | Creation Date | One-to-Many |
| Dim_Kalender | Posteringsdato | Fact_Mål_BR_Faktureret | Deadline | One-to-Many |
| Dim_Kalender | Posteringsdato | Fact_Job_Planning | Planning Date | One-to-Many |

### Dim_Afdeling Relationships
| From Table | From Column | To Table | To Column | Type |
|------------|-------------|----------|-----------|------|
| Dim_Afdeling | Afdelingsnr | Fact_Job | Dim_Job.Afdelings Nr | One-to-Many |
| Dim_Afdeling | Afdelingsnr | Fact_Finans | Global_Dimension_1_Kode | One-to-Many |
| Dim_Afdeling | Afdelingsnr | Fact_Budget | Global Dimension 1 Code | One-to-Many |
| Dim_Afdeling | Afdelingsnr | Fact_Jobcount | Afdelings Nr | One-to-Many |
| Dim_Afdeling | Afdelingsnr | Fact_Mål_BR_Faktureret | Global Dimension Code 1 | One-to-Many |

### Dim_Job Relationships
| From Table | From Column | To Table | To Column | Type |
|------------|-------------|----------|-----------|------|
| Dim_Job | Nr | Fact_Job | Job_Nr | One-to-Many |
| Dim_Job | Nr | Fact_Finans | Jobnummer | One-to-Many |
| Dim_Job | Nr | Fact_Jobcount | Job Nr | One-to-Many |
| Dim_Job | Nr | Fact_Job_Planning | Job No_ | One-to-Many |

### Dim_Konto Relationships
| From Table | From Column | To Table | To Column | Type |
|------------|-------------|----------|-----------|------|
| Dim_Konto | Kontonummer | Fact_Finans | G_L_Kontonummer | One-to-Many |
| Dim_Konto | Kontonummer | Fact_Budget | G_L_Kontonummer | One-to-Many |

### Dim_Kontoplan Relationships
| From Table | From Column | To Table | To Column | Type |
|------------|-------------|----------|-----------|------|
| Dim_Kontoplan | Konto | Fact_Finans | G_L_Kontonummer | One-to-Many |
| Dim_Kontoplan | Konto | Fact_Budget | G_L_Kontonummer | One-to-Many |

### Dim_Resource Relationships
| From Table | From Column | To Table | To Column | Type |
|------------|-------------|----------|-----------|------|
| Dim_Resource | No_ | Fact_Job | Nr | One-to-Many |
| Dim_Resource | No_ | Fact_Jobcount | Person Ansvalig | One-to-Many |

**Note:** Multiple relationships exist between Dim_Konto and Dim_Kontoplan to Fact tables for different analysis perspectives.

---

## 📐 MEASURES & CALCULATIONS

### Measure Table: @Measures
All measures are stored in a dedicated measure table called `@Measures` for better organization.

### Display Folders
Measures are organized into logical folders:
- **Fact_Budget_Measures** - Budget-related metrics
- **Fact_Finans_Measures** - Financial actual metrics
- **Fact_Job_Measures** - Job and project metrics
- **Fact_Mål_BR_Faktureret Measures** - Revenue target metrics

---

## 💰 BUDGET MEASURES

### 1.1 Budget IGVA
**Formula:**
```dax
DIVIDE(
    (CALCULATE(
        SUM('Fact_Budget'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "IGVA",
        RIGHT('Fact_Budget'[Budget_Navn], 3) = "DKB"
    )),
    -1000
)
```
**Purpose:** Budget for IGVA (Indirect Production Value) in thousands DKK  
**Display Folder:** Fact_Budget_Measures  
**Format:** General Number  

---

### 1.1 Budget Omsætning
**Formula:**
```dax
DIVIDE(
    (CALCULATE(
        SUM('Fact_Budget'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "Omsætning",
        RIGHT('Fact_Budget'[Budget_Navn], 3) = "DKB"
    )),
    -1000
)
```
**Purpose:** Budget for revenue (Omsætning) in thousands DKK  
**Display Folder:** Fact_Budget_Measures  
**Format:** General Number  

---

### Budget
**Formula:**
```dax
DIVIDE(
    CALCULATE(
        SUM('Fact_Budget'[Beløb]),
        RIGHT(Fact_Budget[Budget_Navn],3)="DKB"
    ),
    -1000
)
```
**Purpose:** Total budget amount in thousands DKK (DKB budget only)  
**Display Folder:** Fact_Budget_Measures  
**Format:** General Number  

---

### Budget value
**Formula:**
```dax
VAR PosNeg = MAX('Dim_Kontoplan'[Ny_udgift])
VAR Result =
    SWITCH(
        SELECTEDVALUE('Dim_Kontoplan'[Niveau_3]),
        "Omsætning", [1.1 Budget Omsætning],
        "IGVA", [1.1 Budget IGVA]  
    )
RETURN Result
```
**Purpose:** Dynamic budget value based on selected account category  
**Display Folder:** Fact_Budget_Measures  
**Format:** General Number  

---

## 💵 FINANCIAL ACTUAL MEASURES

### 1.1 IGVA
**Formula:**
```dax
DIVIDE(
    CALCULATE(
        SUM('Fact_Finans'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering] = "IGVA"
    ),
    -1000
)
```
**Purpose:** Actual IGVA in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### 1.1 Omsætning
**Formula:**
```dax
//Revenue = Sums Varesalg
DIVIDE(
    CALCULATE(
        SUM('Fact_Finans'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "Omsætning"
    ),
    -1000
)
```
**Purpose:** Actual revenue in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### 1.4 D-Personale
**Formula:**
```dax
DIVIDE(
    CALCULATE(
        SUM('Fact_Finans'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "D-Personale"
    ),
    -1000
)
```
**Purpose:** Direct personnel costs in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** 0  

---

### 1.5 D-Underleverandør
**Formula:**
```dax
DIVIDE(
    CALCULATE(
        SUM(Fact_Finans[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "D-Underleverandør"
    ),
    -1000
)
```
**Purpose:** Subcontractor costs in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### 2.1 I-personale
**Formula:**
```dax
DIVIDE(
    CALCULATE(
        SUM('Fact_Finans'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "I-Personale"
    ),
    -1000
)
```
**Purpose:** Indirect personnel costs in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### 3.1 Adm-Personale
**Formula:**
```dax
DIVIDE(
    CALCULATE(
        SUM('Fact_Finans'[Beløb]),
        'Dim_Kontoplan'[Niveau_2_sortering]= "Adm-Personale"
    ),
    -1000
)
```
**Purpose:** Administrative personnel costs in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### Actual
**Formula:**
```dax
DIVIDE(
    SUM('Fact_Finans'[Beløb]),
    -1000
)
```
**Purpose:** Total actual amount in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### Actual values % of revenue
**Formula:**
```dax
DIVIDE([Actual], [Total omsætning])
```
**Purpose:** Express actual values as percentage of total revenue  
**Display Folder:** Fact_Finans_Measures  

---

### Credit
**Formula:**
```dax
- CALCULATE (
    SUM ('Fact_Finans'[Beløb]),
    'Fact_Finans'[G_L_Kontonummer] IN {
        "1000","1001","1002","1003","1004","1005","1006","1007","1008","1009",
        "1010","1011","1012","1013","1014","1015","1016","1017","1018","1019",
        "1020","1021","1022","1023","1024","1025","1026","1027","1028","1029",
        "1030","1031","1032","1033","1034","1035","1036","1037","1038","1039",
        "1040","1041","1042","1043","1044","1045","1046","1047","1048","1049",
        "1050","1051","1052","1053","1054","1055","1056","1057","1058","1059",
        "1060","1061","1062","1063","1064","1065"
    },
    'Fact_Finans'[Dokumenttype] in {3}
) / 1000
```
**Purpose:** Credit notes in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### Credit notes count
**Formula:**
```dax
CALCULATE(
    DISTINCTCOUNT('Fact_Finans'[Jobnummer]),
    'Dim_Kontoplan'[Niveau_2_sortering] = "Omsætning",
    'Fact_Finans'[Dokumenttype] IN { 3 }
)
```
**Purpose:** Count of jobs with credit notes  
**Display Folder:** Fact_Finans_Measures  
**Format:** 0  

---

### Faktuering
**Formula:**
```dax
- CALCULATE (
    SUM ('Fact_Finans'[Beløb]),
    'Fact_Finans'[G_L_Kontonummer] IN {
        "1000","1001","1002","1003","1004","1005","1006","1007","1008","1009",
        "1010","1011","1012","1013","1014","1015","1016","1017","1018","1019",
        "1020","1021","1022","1023","1024","1025","1026","1027","1028","1029",
        "1030","1031","1032","1033","1034","1035","1036","1037","1038","1039",
        "1040","1041","1042","1043","1044","1045","1046","1047","1048","1049",
        "1050","1051","1052","1053","1054","1055","1056","1057","1058","1059",
        "1060","1061","1062","1063","1064","1065"
    },
    'Fact_Finans'[Dokumenttype] in {2},
    'Fact_Finans'[Kildekode] = "SALG"
) / 1000
```
**Purpose:** Invoice amount in thousands DKK  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### Sales after credits
**Formula:**
```dax
[Faktuering] + [Credit]
```
**Purpose:** Net sales after deducting credit notes  
**Display Folder:** Fact_Finans_Measures  
**Format:** 0  

---

### Total omsætning
**Formula:**
```dax
[1.1 Omsætning] + [1.1 IGVA]
```
**Purpose:** Total revenue (direct + IGVA)  
**Display Folder:** Fact_Finans_Measures  
**Format:** General Number  

---

### IGVA Positive Finans
**Formula:**
```dax
CALCULATE(
    [IGVA Positive],
    Dim_Job[Status NEW] = "Applied Closed" || Dim_Job[Status NEW] = "Open",
    Dim_Job[Nr] <> "INTERN",
    Dim_Job[Creation Date] >= DATE(2023,2,4)
)
```
**Purpose:** IGVA positive for active jobs created after Feb 4, 2023  
**Display Folder:** Fact_Finans_Measures  
**Format:** #,0.0  

---

## 📊 JOB & PROJECT MEASURES

### Abne & Alt
**Formula:**
```dax
CALCULATE(
    COUNT(Dim_Job[Nr]),
    Dim_Job[Status NEW] = "Applied Close" || Dim_Job[Status NEW] = "Open"
)
```
**Purpose:** Count of open and applied close jobs  
**Display Folder:** Fact_Job_Measures  
**Format:** 0  

---

### Invoiced
**Formula:**
```dax
SUM('Fact_Job'[Faktureret])
```
**Purpose:** Total invoiced amount from job ledger  
**Display Folder:** Fact_Job_Measures  
**Format:** #,0  

---

### Kostpris WIP_Limit
**Formula:**
```dax
SUMX(
    SUMMARIZE(
        'Fact_Job',
        'Fact_Job'[Job_Nr],
        'Fact_Job'[RIT Cost Estimate]
    ),
    'Fact_Job'[RIT Cost Estimate]
)
```
**Purpose:** Sum of cost estimates for WIP jobs  
**Display Folder:** Fact_Job_Measures  
**Format:** #,0  

---

### Salgsværdi WIP_Limit
**Formula:**
```dax
SUMX(
    SUMMARIZE(
        'Fact_Job',
        'Fact_Job'[Job_Nr],
        'Fact_Job'[RIT WIP Limit]
    ),
    'Fact_Job'[RIT WIP Limit]
)
```
**Purpose:** Sum of WIP sales value limits  
**Display Folder:** Fact_Job_Measures  
**Format:** General Number  

---

### Salgsværdi WIP_Limit New Orders
**Formula:**
```dax
SUMX(
    SUMMARIZE(
        'Dim_Job',
        'Dim_Job'[Nr],
        'Dim_Job'[RIT WIP Limit]
    ),
    'Dim_Job'[RIT WIP Limit]
)
```
**Purpose:** WIP limit for new orders (from Dim_Job)  
**Display Folder:** Fact_Job_Measures  
**Format:** General Number  

---

### POC all ny
**Formula:**
```dax
DIVIDE([Total Cost], [Kostpris WIP_Limit], 0)
```
**Purpose:** Percentage of Completion (actual cost / estimated cost)  
**Display Folder:** Fact_Job_Measures  

---

### Igva all ny
**Formula:**
```dax
[POC all ny] * [Salgsværdi WIP_Limit] - [Invoiced]
```
**Purpose:** IGVA value (unbilled revenue)  
**Display Folder:** Fact_Job_Measures  

---

### IGVA Margin %
**Formula:**
```dax
([Salgsværdi WIP_Limit] - [Kostpris WIP_Limit]) / [Salgsværdi WIP_Limit]
```
**Purpose:** Profit margin on WIP  
**Display Folder:** Fact_Job_Measures  

---

### IGVA Positive
**Formula:**
```dax
SUMX(
    VALUES(Fact_Job[Job_Nr]),
    VAR RowValue = [POC all ny] * [Salgsværdi WIP_Limit] - [Invoiced]
    RETURN
        IF(RowValue < 0, 0, RowValue)
)
```
**Purpose:** Sum only positive IGVA values (exclude negative)  
**Display Folder:** Fact_Job_Measures  
**Format:** #,0.0  

---

### Total Cost
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Samlede_Omkostninger (LCY)]),
    'Fact_Job'[Source Code]<>"SALG"
)
```
**Purpose:** Total cost on jobs (excluding sales transactions)  
**Display Folder:** Fact_Job_Measures  
**Format:** #,0  

---

### Tilbud/Screening
**Formula:**
```dax
SUM(Fact_Job_Planning[Total Price])
```
**Purpose:** Total quote/screening value  
**Display Folder:** Fact_Job_Measures  
**Format:** #,0  

---

## ⏰ TIME TRACKING MEASURES

### adm timer
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Arbejdstypekode] = "2050",
    'Fact_Job'[Task Code grouping] = "Internal Adm",
    'Fact_Job'[Dokument_Nr] IN {"TIMEENTRY", "RETTELSE"}
)
```
**Purpose:** Administrative hours  
**Display Folder:** Fact_Job_Measures  

---

### møde timer
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Task Code grouping] = "Internal Meeting",
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Meeting hours  
**Display Folder:** Fact_Job_Measures  

---

### kundebesøg timer
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Task Code grouping] = "Internal Customer Visits",
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Customer visit hours  
**Display Folder:** Fact_Job_Measures  

---

### træning timer
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Task Code grouping] = "Internal Course",
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Training hours  
**Display Folder:** Fact_Job_Measures  

---

### Total interne time
**Formula:**
```dax
[adm timer] + [møde timer] + [kundebesøg timer] + [træning timer]
```
**Purpose:** Total non-billable internal hours  
**Display Folder:** Fact_Job_Measures  

---

### Ferie
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Arbejdstypekode] = "2060",
    NOT 'Dim_Resource'[Lessor_Payment_Type] IN {0,3},
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Vacation hours (excluding contractors)  
**Display Folder:** Fact_Job_Measures  

---

### Flex
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Arbejdstypekode] in {"2070"},
    NOT Dim_Resource[Lessor_Payment_Type] IN {0,3},
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Flex time hours  
**Display Folder:** Fact_Job_Measures  

---

### Ferie/flex total
**Formula:**
```dax
[Flex] + [Ferie]
```
**Purpose:** Combined vacation and flex hours  
**Display Folder:** Fact_Job_Measures  

---

### Interne medarbejde normtid på projekt
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Entry_Type] IN {0,3},
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Normal project hours (internal employees)  
**Display Folder:** Fact_Job_Measures  

---

### Interne medarbejde overtid på projekt
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Fact_Job'[Entry_Type] IN {1,4},
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Overtime hours (internal employees)  
**Display Folder:** Fact_Job_Measures  

---

### vikar normtid på projekt
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Dim_Resource'[Lessor_Payment_Type] IN {0,3},
    'Fact_Job'[Entry_Type] IN {0,3},
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Normal hours (contractors/temps)  
**Display Folder:** Fact_Job_Measures  

---

### vikar overtid på projekt
**Formula:**
```dax
CALCULATE(
    SUM('Fact_Job'[Mængde]),
    'Dim_Resource'[Lessor_Payment_Type] IN {0,3},
    'Fact_Job'[Entry_Type] IN {1,4},
    'Fact_Job'[Dokument_Nr] IN {"Timeentry", "RETTELSE"}
)
```
**Purpose:** Overtime hours (contractors/temps)  
**Display Folder:** Fact_Job_Measures  

---

### Total projekt normtimer
**Formula:**
```dax
[Interne medarbejde normtid på projekt] + [vikar normtid på projekt]
```
**Purpose:** Total normal project hours  
**Display Folder:** Fact_Job_Measures  

---

### Overtid %
**Formula:**
```dax
DIVIDE(
    [Interne medarbejde overtid på projekt] + [vikar overtid på projekt],
    [Total projekt normtimer]
)
```
**Purpose:** Overtime percentage  
**Display Folder:** Fact_Job_Measures  

---

## 🎯 TARGET MEASURES

### Goal BR
**Formula:**
```dax
IF(
    [Faktuering] > 0,
    SUM('Fact_Mål_BR_Faktureret'[Måltal TDKK])
)
```
**Purpose:** Revenue target (only shown if invoicing > 0)  
**Display Folder:** Fact_Mål_BR_Faktureret Measures  
**Format:** 0  

---

## 🔢 CALCULATED COLUMNS

### Fact_Job Calculated Columns

#### Faktureret (Invoiced)
**Logic:**
```m
if [Source Code] = "SALG" 
then -[Total Price (LCY)]
else null
```
**Purpose:** Extract invoiced amount from sales transactions
**Data Type:** Decimal

#### Salg (Sales)
**Logic:**
```m
if [Source Code] = "SALG" or [Source Code] = "IGVA_KORR"
then 0
else [Total Price (LCY)]
```
**Purpose:** Separate sales value (exclude sales and IGVA correction transactions)
**Data Type:** Decimal

#### Omkostning (Cost)
**Logic:**
```m
if [Source Code] = "SALG" or [Source Code] = "IGVA_KORR"
then 0
else [Total Cost (LCY)]
```
**Purpose:** Separate cost value (exclude sales and IGVA correction transactions)
**Data Type:** Decimal

#### Task Code grouping
**Logic:** Lookup mapping based on Jobopgave_Nr (Job Task No.)
**Mapping:**
- 002, 015 → "Absense Sick"
- 003, 013, 019, 022, 0034 → "Absense Sick+"
- 005 → "Absense Maternity"
- 007, 008, 004, 017, 014, 012 → "Absense Holiday"
- 009, 010, 021, 047 → "Internal Course"
- 011 → "Internal Meeting"
- 049 → "Internal Customer Visits"
- 031, 037, 038, 039, 045, 046, 0038, 016 → "Internal Adm"
- 018 → "Other Flex"
- 065, 082, 083 → "Other On-call"
- Default → "Other"
**Purpose:** Group 40+ task codes into reportable categories
**Data Type:** Text

#### Måned (Month)
**Logic:** 
```m
Date.Month([Posting Date])
```
**Purpose:** Extract month number from posting date
**Data Type:** Integer

---

### Dim_Kalender Calculated Columns

#### BelforPeriodefraidag (Periods from today)
**Logic:**
```m
if [År] = TodayYear then TodayPeriodNum - [Periode_Nummer]
else if [År] < TodayYear then ((TodayYear - [År]) * 12) + (TodayPeriodNum - [Periode_Nummer])
else ((TodayYear - [År]) * 12) + (TodayPeriodNum - [Periode_Nummer])
```
**Purpose:** Calculate how many Belfor periods ago from today
**Data Type:** Integer
**Example:** -3 means 3 periods ago, 0 means current period, 2 means 2 periods in future

---

### Dim_Konto Calculated Columns

#### Kontonummer/Kontonavn (Account Number/Name)
**Logic:**
```m
Text.Combine({Text.From([Kontonummer]), [Kontonavn]}, " ")
```
**Purpose:** Combined field for dropdowns and displays
**Data Type:** Text

---

## 🔄 Refresh Schedule

### Production Environment
- **Frequency:** Daily
- **Time:** 02:00 AM CET (overnight)
- **Duration:** Approximately 45-60 minutes
- **Method:** Scheduled refresh via Power BI Service

### Data Source Refresh Dependencies
1. **Business Central SQL:** Real-time data (refreshed overnight in source)
2. **Power Platform Dataflows:** Refresh 1 hour before model refresh (01:00 AM)
3. **SharePoint Files:** Updated manually by business users (files read during refresh)

### Refresh Process
1. Dataflow refresh completes (01:00 AM)
2. Model refresh starts (02:00 AM)
3. All queries execute in parallel (where possible)
4. Relationships recalculated
5. Measures evaluated
6. Model published to service
7. Reports updated (03:00-03:30 AM)

---

## 🔐 Security & Access

### Row-Level Security (RLS)
**Status:** Not currently implemented
**Reason:** All users have access to all departments (small organization)
**Future Consideration:** May implement if organization grows or data sensitivity increases

### Report Access
**Controlled by:** Power BI Service workspace permissions
**User Groups:**
- **Viewers:** Can view and interact with reports
- **Contributors:** Can view, edit, and create reports
- **Admins:** Full control including dataset refresh

### Data Source Credentials
- **SQL Server:** Service account with read-only access
- **Dataflows:** OAuth authentication
- **SharePoint:** OAuth authentication via organizational account
- **Credentials stored:** Power BI Service (encrypted)

---

## ⚠️ Known Limitations

### 1. Data Granularity
- **Financial Data:** Transaction level (very granular)
- **Budget Data:** Monthly level only
- **Time Tracking:** Daily/transaction level

### 2. Historical Data
- **Available from:** January 2022 onwards
- **Prior periods:** Opening balances only (no transaction detail)

### 3. Real-Time Data
- **Not real-time:** Data refreshes overnight
- **Latest data:** Previous day's close
- **Intraday changes:** Not reflected until next refresh

### 4. External Data
- **MongoDB data:** Refreshes via Dataflow (may have slight lag)
- **SharePoint files:** Manual updates required

### 5. Performance
- **Large datasets:** Some queries may take 3-5 seconds
- **Complex calculations:** WIP calculations can be slow for large filters

### 6. Language
- **Mixed language:** Some fields Danish, some English
- **No translation:** Single language model

### 7. Measure Documentation
- **Limited descriptions:** Most measures lack detailed descriptions
- **Business logic:** Not fully documented in model
- **User training:** Required to understand measure meanings

---

## 📈 Usage Statistics

### Report Usage (Estimated)
- **Daily active users:** 15-20
- **Weekly active users:** 40-50
- **Monthly active users:** 60-70
- **Peak usage:** Monday mornings and month-end

### Most Used Reports
1. Financial overview (Budget vs Actual)
2. Department performance
3. Project profitability (WIP analysis)
4. Time tracking and utilization
5. Revenue pipeline

### Most Used Measures
1. Total omsætning (Total Revenue)
2. Budget vs Actual comparison
3. IGVA Positive
4. Total projekt normtimer (Project Hours)
5. Faktuering (Invoicing)

---

## 🎯 Future Enhancements (Planned)

### Short Term (1-3 months)
- Add measure descriptions to all calculations
- Standardize number formatting
- Improve query performance (remove redundant merges)
- Add data quality checks

### Medium Term (3-6 months)
- Implement year-over-year comparison measures
- Add rolling 12-month calculations
- Create calculation groups for time intelligence
- Improve date table (proper date dimension)

### Long Term (6-12 months)
- Row-level security implementation
- Mobile-optimized reports
- Predictive analytics (forecasting)
- Integration with additional data sources
- Automated anomaly detection

---

## 📞 Support & Contacts

### Business Owner
**Department:** Finance  
**Contact:** finance@company.com

### Technical Owner
**Department:** BI Team  
**Contact:** bi-team@company.com

### Data Sources
**Business Central Administrator:** IT Department  
**SharePoint Administrator:** IT Department  
**Power Platform Administrator:** IT Department

### Issue Reporting
**Method:** Email to bi-team@company.com  
**Include:** Screenshot, description, filters used, expected vs actual result  
**Response Time:** 24-48 hours for non-critical issues

---

## 📚 Appendix

### A. Query Group Hierarchy
```
Helper Tables (15 queries)
├── Dim_Afdeling (helper)
├── Dim_Customer (helper)
├── Dim_Sag (helper)
├── Mongo Categories
├── Mongo Causes
├── Mongo Location
├── Mongo Department
├── Finansposter (opening balances)
├── Man Postings (manual adjustments)
├── Man Temps
├── bc Resource_system
├── Data (mapping helper)
├── Dim_Dimension_Set (helper)
├── Dim_Belfor_Kalender (helper)
└── Dim_Job_1 (helper)

Dim Tables (7 queries)
├── Dim_Afdeling
├── Dim_Kalender
├── Dim_Konto
├── Dim_Kontoplan
├── Dim_Resource
├── Dim_Job
└── Dim_Sag

Fact_Tables (6 queries)
├── Fact_Job
├── Fact_Finans
├── Fact_Budget
├── Fact_Job_Planning
├── Fact_Jobcount
└── Fact_Mål_BR_Faktureret

Other
└── @measure table (calculation table)
```

### B. Data Lineage Summary
```
Business Central SQL
│
├─→ Fact_Job (Job Ledger Entry)
├─→ Dim_Job (Job master)
├─→ Fact_Jobcount (Job creation tracking)
└─→ Fact_Job_Planning (Planning lines)

Power Platform Dataflows
│
├─→ Fact_Finans (G/L Entry)
├─→ Dim_Konto (G/L Account)
├─→ Dim_Resource (Resource with custom fields)
└─→ Dim_Sag (MongoDB Cases + related entities)

SharePoint Files
│
├─→ Fact_Budget (Budget Excel)
├─→ Dim_Kalender (Calendar Excel)
├─→ Dim_Kontoplan (Mapping Tables Excel)
├─→ Fact_Mål_BR_Faktureret (Targets Excel)
├─→ Finansposter (Opening Balances Excel)
└─→ Man Postings (Manual Adjustments Excel)
```

### C. Key Business Rules

**Revenue Recognition:**
- Direct revenue: When invoiced (Faktuering)
- IGVA: Based on POC (Percentage of Completion)
- POC calculated as: Actual Cost / Estimated Total Cost

**Budget Filtering:**
- Only budgets ending in "DKB" are included in main budget measures
- Other budgets exist but are not shown in primary reports

**Account Hierarchy:**
- Level 2 categories determine P&L grouping
- `Ny_udgift` flag: -1 = Income (reverse sign), 1 = Expense (normal sign)
- This is why revenue appears as positive (negative numbers reversed)

**Time Tracking:**
- Entry_Type: 0,3 = Normal time, 1,4 = Overtime
- Lessor_Payment_Type: 0,3 = Contractors (excluded from some calculations)
- Only "TIMEENTRY" and "RETTELSE" documents counted

**Task Code Grouping:**
- 40+ task codes mapped to ~10 categories
- Enables simpler reporting and analysis
- Absense, Internal, and Project work categorized

**WIP Calculation:**
- WIP Limit: Maximum revenue allowed to recognize
- Cost Estimate: Expected total cost of job
- POC: Actual Cost / Cost Estimate
- IGVA: (POC × WIP Limit) - Invoiced
- Margin %: (WIP Limit - Cost Estimate) / WIP Limit

---

## 📝 Version History

**Version 1.0 - October 2025**
- Initial production release
- All fact and dimension tables implemented
- Core financial, project, and time tracking measures
- Integration with Business Central, MongoDB, and SharePoint
- Daily refresh schedule established

**Development History:**
- Phase 1: Data source connection (2 weeks)
- Phase 2: Transformation logic (4 weeks)
- Phase 3: Model design and relationships (2 weeks)
- Phase 4: Measure development (3 weeks)
- Phase 5: Testing and validation (2 weeks)
- Phase 6: User training and deployment (1 week)
- **Total development time:** ~14 weeks

---

## ✅ Sign-Off

**Developed by:** BI Development Team  
**Approved by:** Finance Department  
**Deployed on:** [Deployment Date]  
**Status:** In Production  

**Documentation Prepared by:** BI Team  
**Document Date:** October 2025  
**Document Status:** Current As-Built  

---

**END OF DOCUMENT**

*This document represents the current state of the BelFor Power BI semantic model as implemented in production. For any questions, clarifications, or change requests, please contact the BI team.*

