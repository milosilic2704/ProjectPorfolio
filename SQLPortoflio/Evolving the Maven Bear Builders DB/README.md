# 🛠️ A Database Administrator's Case Study: Evolving the Maven Bear Builders DB

<div align="center">

![MySQL](https://img.shields.io/badge/MySQL-Expert-orange?style=for-the-badge&logo=mysql)
![Database Design](https://img.shields.io/badge/Database%20Design-Advanced-red?style=for-the-badge)
![Data Architecture](https://img.shields.io/badge/Data%20Architecture-Expert-blue?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐⭐⭐-yellow?style=for-the-badge)

</div>

---

## 📋 Project Overview

**Role**: Database Administrator & Data Architect  
**Database**: MySQL (mavenbearbuilders)  
**Industry**: E-commerce Manufacturing  
**Project Type**: Enterprise Database Evolution & Optimization

Maven Bear Builders was facing a common but critical challenge of success: **its operational data was outgrowing its initial database structure**. As the business expanded and new sales strategies were developed, the CEO required a more robust and scalable database. As the Database Administrator, I was tasked with not only importing a year's worth of new data but also **evolving the database schema** to support new analytics, enhance data integrity, and establish a comprehensive backup and recovery plan.

---

## 🎯 Project Objectives

### **Strategic Business Goals**
1. **🔧 Database Evolution** - Modernize schema for new business requirements
2. **📊 Data Integration** - Import and consolidate Q2 transaction data
3. **🛡️ Data Security** - Implement integrity constraints and security measures
4. **💼 Acquisition Support** - Prepare database for potential company acquisition
5. **💬 Chat Support Infrastructure** - Design new system for customer support tracking

### **Technical Deliverables**
- Complete data import and validation system
- Advanced database schema modifications
- Chat support tracking architecture
- Security audit and recommendations
- Acquisition-ready reporting views

---

## 🏗️ Project Architecture & Implementation

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

#### **Security & Integrity Enhancements**
🛡️ **Data Validation**: Prevented incomplete records through NOT NULL constraints  
🔗 **Referential Integrity**: Established foreign key relationships  
⚡ **Performance Optimization**: Enhanced query performance through proper indexing  
🚫 **Error Prevention**: Database-level validation preventing data corruption

---

## **Step 5: Strategic Planning for Data Security and Recovery**

Objective: In response to a board advisor's concerns, I was asked to prepare a formal report on data loss risks and a corresponding mitigation and recovery plan, creating a dump.

<img width="973" height="732" alt="image" src="https://github.com/user-attachments/assets/487dd109-c246-46f9-bac4-6544a16dcde5" />

---

## 🎓 Technical Skills Demonstrated

### **Database Administration**
- **Schema Evolution** - Complex ALTER TABLE operations
- **Data Migration** - Large-scale CSV import and validation
- **Constraint Management** - NOT NULL and foreign key implementation
- **User Management** - Role-based access control

### **Database Design**
- **Normalization** - Proper table relationships and foreign keys
- **Business Logic** - Boolean flags for business intelligence
- **Performance Optimization** - Efficient data types and indexing
- **Scalability Planning** - Architecture for future growth

### **Data Integrity & Security**
- **Referential Integrity** - Foreign key constraint implementation
- **Data Validation** - NOT NULL constraints for critical fields
- **Access Control** - Restricted user creation and permissions
- **Backup Strategy** - Comprehensive data protection planning

### **Business Intelligence**
- **Cross-Selling Analytics** - Primary item tracking implementation
- **Executive Reporting** - Management dashboard views
- **Performance Metrics** - Chat support KPI tracking
- **Acquisition Readiness** - Due diligence data preparation

---

## 📊 Business Impact & Results

### **Operational Excellence**
- **📈 Data Quality**: Implemented enterprise-grade data integrity constraints
- **⚡ Performance**: Optimized database structure for improved query performance
- **🔄 Scalability**: Designed architecture to support business growth and new features
- **🛡️ Security**: Established robust data protection and access control measures

### **Strategic Business Value**
- **💼 Acquisition Ready**: Created investor-friendly reporting views and documentation
- **📞 Customer Service**: Designed comprehensive chat support tracking system
- **📊 Business Intelligence**: Enabled cross-selling analytics and performance tracking
- **🎯 Decision Support**: Provided complete data foundation for strategic planning

### **Technical Achievements**
- **🗃️ Data Integration**: Successfully imported and validated 10,199+ transaction records
- **🏗️ Schema Evolution**: Implemented complex database structure changes without downtime
- **🔗 Referential Integrity**: Established proper table relationships and constraints
- **👥 Multi-User Architecture**: Created secure, role-based access control system

---

## 🏁 Conclusion

This project transformed Maven Bear Builders' database from a basic data storage system into a **strategic business asset**. The evolution didn't just add more information—it made the entire system **smarter, safer, and more scalable**.

**Key Accomplishments:**
- **Enterprise-Grade Architecture**: Evolved database to support complex business requirements
- **Data-Driven Decision Making**: Enabled comprehensive analytics and reporting capabilities  
- **Security & Compliance**: Implemented robust data protection and integrity measures
- **Acquisition Readiness**: Created professional, auditable database structure for potential buyers
- **Future-Proof Design**: Established scalable architecture for continued business growth

The company can now confidently launch new sales strategies, provide exceptional customer support through the chat system, and demonstrate robust data management practices to potential acquirers—all while ensuring data security and integrity at the enterprise level.

---

<div align="center">

**🔗 [View Complete Code Repository](../)**  
**📊 [Back to SQL Projects Portfolio](../)**

</div>
