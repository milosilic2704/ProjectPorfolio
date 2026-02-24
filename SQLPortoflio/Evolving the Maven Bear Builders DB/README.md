# 🛠️ A Database Administrator's Case Study: Evolving the Maven Bear Builders DB

<div align="center">

![MySQL](https://img.shields.io/badge/MySQL-Expert-orange?style=for-the-badge&logo=mysql)
![Database Design](https://img.shields.io/badge/Database%20Design-Advanced-red?style=for-the-badge)
![Data Architecture](https://img.shields.io/badge/Data%20Architecture-Expert-blue?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐⭐-lightgray?style=for-the-badge)

</div>

---

## Introduction

Dive into enterprise database administration! This project follows Maven Bear Builders through a critical growth phase, where I evolved their MySQL database schema to support new business strategies, imported and validated a full year of transaction data, and established robust data integrity, security, and backup systems.

SQL scripts? Check them out here: [Milos_MavenBearBuilders_Course_Project.sql](https://github.com/milosilic2704/ProjectPorfolio/blob/main/SQLPortoflio/Evolving%20the%20Maven%20Bear%20Builders%20DB/Milos_MavenBearBuilders_Course_Project.sql)

---

## Background

Driven by Maven Bear Builders' rapid growth, the company's original database structure was no longer sufficient to support new business strategies, an upcoming acquisition, and a planned chat-support feature. As the Database Administrator, I was tasked with evolving the schema, importing 10,000+ transaction records, and securing the data foundation for the business's next chapter.

### The objectives I set out to achieve:

1. Import and validate all Q2 and H2 transaction data to build a complete annual dataset.
2. Modify the database schema to support a new cross-selling strategy.
3. Ensure historical data consistency after the schema change.
4. Expand the product catalogue and import the remaining 2013 transaction data.
5. Implement enterprise-grade data integrity constraints and access controls.
6. Prepare a formal data security and disaster recovery report.

---

## Tools I Used

For this deep dive into database administration and schema evolution, I used several key tools:

- **SQL** — The backbone of all schema changes, data imports, and integrity constraint implementations.
- **MySQL** — The database management system hosting the `mavenbearbuilders` database.
- **MySQL Workbench** — Used for schema design (EER diagrams), data import wizards, and query execution.
- **Git & GitHub** — Essential for version control of all SQL scripts, ensuring a full audit trail of every database change made.

---

## The Analysis

### **Step 1: Creating a Complete Picture (Q2 Data Import)**

#### **Objective**
The immediate goal was to consolidate all transaction data by importing the sales and refund records from the second quarter.

#### **Process & Implementation**
The data was supplied in two separate CSV files: 08.order_items_2013_Apr-June.csv and 09.order_item_refunds_2013_Apr-June.csv. I used MySQL Import Wizard in order to efficiently and accurately import these records into their respective tables, order_items and order_item_refunds.

**Data Import Strategy:**
- **Files Processed**: `08.order_items_2013_Apr-June.csv` and `09.order_item_refunds_2013_Apr-June.csv`
- **Import Method**: MySQL Import Wizard for efficient and accurate data loading
- **Validation**: Comprehensive data verification post-import

<img width="1367" height="700" alt="image" src="https://github.com/user-attachments/assets/b6589854-6ba1-45db-9181-89743ec16102" />

#### **Business Impact**
✅ Successfully integrated Q2 data providing complete transaction history for first half of year  
✅ Enabled leadership team to perform meaningful performance analysis  
✅ Created foundation for strategic decision-making with comprehensive dataset

<img width="540" height="236" alt="image" src="https://github.com/user-attachments/assets/c08b6bbd-9290-40c9-bc84-b670bd7061b7" />

<img width="603" height="242" alt="image" src="https://github.com/user-attachments/assets/3479399e-2f2c-4706-b00a-132f3c509f56" />



---

### **Step 2: Adapting the Schema for New Business Insights**

#### **Objective**
The company planned to introduce **cross-selling strategies**. We needed a way to differentiate between a primary purchase and a cross-sold item within the same order.

#### **Technical Implementation**
```sql
-- Adding new business intelligence column
ALTER TABLE order_items
ADD COLUMN is_primary_item BOOLEAN
AFTER product_id;
```

**Schema Evolution Strategy:**
- **New Column**: `is_primary_item` (BOOLEAN data type)
- **Purpose**: Track cross-selling campaign effectiveness
- **Data Type Rationale**: Space-efficient boolean storage (`1` for true, `0` for false)

<img width="1067" height="301" alt="image" src="https://github.com/user-attachments/assets/c32c2000-d02c-43a9-99b9-1520b617454f" />


#### **Business Value**
🎯 **Cross-Selling Analytics**: Enabled measurement of new sales strategy success  
📈 **Revenue Optimization**: Provided foundation for analyzing primary vs. cross-sold item performance  
🔍 **Campaign Effectiveness**: Created ability to track and optimize cross-selling initiatives

---

### **Step 3: Ensuring Historical Data Consistency**

#### **Objective**
The newly added `is_primary_item` column was NULL for all existing records. To maintain data integrity, historical records needed to be updated to reflect that all items sold prior to the new strategy were, by definition, primary items.

#### **Implementation**
```sql
-- Update historical data for consistency
UPDATE order_items
SET is_primary_item = 1
WHERE order_item_id > 0;

```

#### **Data Integrity Outcome**
✅ **Historical Accuracy**: All previous records correctly marked as primary items  
✅ **Data Consistency**: Eliminated NULL values for business-critical field  
✅ **Future-Proof Structure**: Established clean baseline for new cross-selling tracking

<img width="1142" height="711" alt="image" src="https://github.com/user-attachments/assets/468fb724-0e6d-4d04-b1c9-a464b09eec8f" />


---

### **Step 4: Completing the Annual Data Set**

#### **Objective**
To finalize the 2013 dataset, two new products needed to be added to the catalog before importing the final six months of transaction data.

#### **Product Catalog Enhancement**
```sql
-- Adding new products to support complete data import
INSERT INTO product VALUES
(3, '2013-12-12 09:00:00', 'The Birthday Sugar Panda'),
(4, '2014-12-05 10:00:00', 'The Hudson River Mini bear');

```

**Data Import Completion:**
- **Files Processed**: `10.order_items_2013_Jul-Dec.csv` and `11.order_item_refunds_2013_Jul-Dec.csv`
- **Final Dataset**: Complete 2013 transaction history with **10,199 total orders**
- **Product Expansion**: Catalog extended to support full product range

#### **Annual Data Results**
📊 **Total Orders**: 10,199 (complete annual dataset)  
📦 **Total Refunds**: 508 (comprehensive refund tracking)  
🎯 **Product Range**: 4 complete product lines with full transaction history

<img width="733" height="381" alt="image" src="https://github.com/user-attachments/assets/595f2106-e42f-49fc-9d6c-63cc2c6d5d2d" />

<img width="471" height="240" alt="image" src="https://github.com/user-attachments/assets/4d70948f-d019-41b6-85b0-ce624590f1b1" />

<img width="627" height="233" alt="image" src="https://github.com/user-attachments/assets/dc6f00eb-97b7-4434-aa3a-ca9840f3685a" />




---

### **Step 5: Fortifying the Database with Integrity Constraints**

#### **Objective**
As the database grew in importance, the CEO prioritized data integrity to prevent errors and ensure reliability. My task was to identify and enforce rules on critical data columns..

#### **Database Hardening Implementation**
```sql
ALTER TABLE `mavenbearbuilders`.`order_item_refunds` 
DROP FOREIGN KEY `order_item_id`;
ALTER TABLE `mavenbearbuilders`.`order_item_refunds` 
CHANGE COLUMN `created_at` `created_at` DATETIME NOT NULL ,
CHANGE COLUMN `order_item_id` `order_item_id` INT NOT NULL ,
CHANGE COLUMN `order_id` `order_id` INT NOT NULL ,
CHANGE COLUMN `refund_amount_usd` `refund_amount_usd` DECIMAL(6,2) NOT NULL ;
ALTER TABLE `mavenbearbuilders`.`order_item_refunds` 
ADD CONSTRAINT `order_item_id`
  FOREIGN KEY (`order_item_id`)
  REFERENCES `mavenbearbuilders`.`order_items` (`order_item_id`);
  
  ALTER TABLE `mavenbearbuilders`.`order_items` 
DROP FOREIGN KEY `product_id`;
ALTER TABLE `mavenbearbuilders`.`order_items` 
CHANGE COLUMN `created_at` `created_at` DATETIME NOT NULL ,
CHANGE COLUMN `order_id` `order_id` INT NOT NULL ,
CHANGE COLUMN `price_usd` `price_usd` DECIMAL(6,2) NOT NULL ,
CHANGE COLUMN `website_session_id` `website_session_id` BIGINT NOT NULL ,
CHANGE COLUMN `product_id` `product_id` BIGINT NOT NULL ,
CHANGE COLUMN `is_primary_item` `is_primary_item` TINYINT(1) NOT NULL ;
ALTER TABLE `mavenbearbuilders`.`order_items` 
ADD CONSTRAINT `product_id`
  FOREIGN KEY (`product_id`)
  REFERENCES `mavenbearbuilders`.`product` (`product_id`);

ALTER TABLE `mavenbearbuilders`.`product` 
CHANGE COLUMN `created_at` `created_at` DATETIME NOT NULL ,
CHANGE COLUMN `product_name` `product_name` VARCHAR(120) NOT NULL ,
ADD UNIQUE INDEX `product_name_UNIQUE` (`product_name` ASC) VISIBLE;
```

#### Key Findings

- **NOT NULL constraints prevent silent data corruption** — Adding database-level validation to critical columns (amounts, dates, foreign keys) ensures that incomplete records can never be written, eliminating entire categories of analytical errors downstream.
- **Foreign key constraints enforce referential integrity automatically** — Rather than relying on application-layer checks, database-enforced relationships between `order_item_refunds`, `order_items`, and `product` tables guarantee that no orphaned records can exist.
- **Unique indexing protects business-critical data** — Adding a `UNIQUE` constraint on `product_name` prevents duplicate product entries that could otherwise distort revenue calculations and cross-selling analytics.

---

## **Step 6: Strategic Planning for Data Security and Recovery**

In response to a board advisor's concerns, I was asked to prepare a formal report on data loss risks and a corresponding mitigation and recovery plan, including creating a database dump.

<img width="973" height="732" alt="image" src="https://github.com/user-attachments/assets/487dd109-c246-46f9-bac4-6544a16dcde5" />

---

## What I Learned

This project significantly expanded my database administration capabilities and deepened my understanding of enterprise-grade MySQL management:

- **Schema changes require a data migration mindset** — Adding a new column like `is_primary_item` is only half the task; ensuring historical records are correctly back-filled with `UPDATE` statements is equally critical to prevent misleading NULL values from skewing future analysis.
- **Constraints are a DBA's first line of defence** — Implementing `NOT NULL`, `FOREIGN KEY`, and `UNIQUE` constraints at the database level is far more reliable than application-level checks, as they are enforced regardless of how the data enters the system.
- **Import and validation are inseparable** — Every data import step required an immediate verification query to confirm row counts and date ranges, reinforcing that data quality assurance is a continuous process, not a one-time step.
- **Business context drives technical decisions** — Each schema change (the `is_primary_item` boolean, the chat support tables, the acquisition views) was driven by a specific business requirement. Understanding *why* a change is needed is just as important as knowing *how* to implement it.

---

## Conclusion

This project transformed Maven Bear Builders' database from a basic data storage system into a **strategic business asset**. The evolution didn't just add more information — it made the entire system smarter, safer, and more scalable.

1. **Schema evolution must be planned, not improvised** — Each ALTER TABLE operation was preceded by a clear business justification, ensuring the database structure accurately reflected the company's operational reality.
2. **10,199+ records imported with zero data integrity failures** — The combination of the Import Wizard and immediate post-import validation queries ensured a clean, complete dataset for all downstream analysis.
3. **Database security is a business priority, not a technical afterthought** — Implementing role-based access control and formalising a backup and recovery plan directly addressed the board's concerns and strengthened the company's acquisition case.
4. **A well-designed database enables better business decisions** — The cross-selling analytics enabled by the `is_primary_item` column, and the management views created for the acquisition, demonstrate that good database architecture directly translates into business intelligence capability.
5. **The DBA role bridges technical and business worlds** — Every decision in this project had both a technical implementation and a business consequence, reinforcing that database administration is fundamentally about enabling better organisational outcomes.

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/milosilic2704/ProjectPorfolio/blob/main/SQLPortoflio/Evolving%20the%20Maven%20Bear%20Builders%20DB/Milos_MavenBearBuilders_Course_Project.sql)**  
**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
