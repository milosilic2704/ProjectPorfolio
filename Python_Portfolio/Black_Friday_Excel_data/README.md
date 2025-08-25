# 🎿 Maven Ski Shop: Black Friday Sales Analysis with Python

<div align="center">

![Python](https://img.shields.io/badge/Python-Intermediate-blue?style=for-the-badge&logo=python)
![Excel](https://img.shields.io/badge/Excel%20Automation-Advanced-green?style=for-the-badge&logo=microsoft-excel)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-Advanced-orange?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐-yellow?style=for-the-badge)

</div>

---

## 📋 Project Overview

**Role**: Data Analyst  
**Technology Stack**: Python, openpyxl, Jupyter Notebooks  
**Industry**: Retail Sports Equipment  
**Project Type**: Black Friday Sales Performance Analysis & Excel Automation

**The Challenge**: Sally Snow, the Ski Shop Manager, needed urgent help analyzing Black Friday sales data. The Excel workbook was missing critical calculations for taxes and totals, and she needed comprehensive business insights to understand the success of their biggest sales event of the year.

**The Solution**: Developed a complete Python-based data processing and analysis pipeline that not only fixed the missing data but provided actionable business intelligence for strategic decision-making.

---

## 🚀 Project Structure

### **PART 1: DATA PREPARATION**

**Objectives:**
1. Read and manipulate Excel data programmatically
2. Create reusable functions for data processing
3. Build comprehensive data structures using Python
4. Automate sales tax calculations across multiple locations
5. Write processed data back to Excel workbooks

### **PART 2: DATA ANALYSIS** 

**Objectives:**
1. Calculate key business metrics through data aggregation
2. Perform customer behavior analysis
3. Analyze sales performance by location
4. Create flexible analytical functions for ongoing reporting
5. Derive actionable insights for business optimization

---

## 🛠️ Technical Implementation

### **Phase 1: Excel Data Integration**

#### **Setting Up the Data Pipeline**
```python
import openpyxl as xl
from pprint import pprint

# Load the Excel workbook and access order data
wb = xl.load_workbook(filename='maven_ski_shop_data.xlsx')
orders = wb['Orders_Info']
```

#### **Building Reusable Functions**
Created a utility function for data inspection and validation:

```python
def column_printer(sheet, column):
    """
    Helper function to print all rows in a specified column.
    Enables data review without opening Excel files.
    """
    for i in range(1, sheet.max_row + 1):
        print(f'{column}{i}', sheet[f'{column}{i}'].value)
```

---

### **Phase 2: Advanced Data Structure Creation**

#### **Order Data Dictionary Construction**
```python
order_dict = {
    orders[f'A{order}'].value: [
        orders[f'B{order}'].value,  # Customer ID
        orders[f'C{order}'].value,  # Date
        orders[f'D{order}'].value,  # Subtotal
        orders[f'G{order}'].value,  # Location
        str(orders[f'H{order}'].value).split(', ')  # Items Ordered (converted to list)
    ]
    for order in range(2, orders.max_row + 1)
    if orders[f'A{order}'].value is not None
}
```

**Key Technical Achievements:**
- **Dictionary Comprehension**: Efficient data structure creation
- **String Processing**: Automatic conversion of comma-separated items to lists
- **Data Validation**: Built-in null value filtering
- **Memory Optimization**: Single-pass data extraction

---

### **Phase 3: Automated Sales Tax Calculation System**

#### **Multi-Location Tax Processing**
```python
from tax_calculator import tax_calculator

# Apply location-specific tax rates
for order in order_dict.values():
    if order[3] == 'Sun Valley':
        transaction = tax_calculator(order[2], .08)      # 8% tax
    elif order[3] == 'Mammoth':
        transaction = tax_calculator(order[2], .0775)    # 7.75% tax
    else:  # Stowe
        transaction = tax_calculator(order[2], .06)      # 6% tax
    
    # Insert calculated tax and total into data structure
    order.insert(3, transaction[1])  # Tax amount
    order.insert(4, transaction[2])  # Final total
```

#### **Excel Workbook Update & Persistence**
```python
# Write calculated values back to Excel
for index, order in enumerate(order_dict.values(), start=2):
    orders[f'E{index}'] = order[3]  # Sales tax
    orders[f'F{index}'] = order[4]  # Total amount

# Save the enhanced workbook
wb.save('maven_ski_shop_data_fixed.xlsx')
```

**Business Impact**:
- **Automated Tax Compliance**: Ensured accurate tax calculations across all locations
- **Data Completeness**: Eliminated missing data fields preventing analysis
- **Audit Trail**: Maintained original data while adding calculated fields

---

## 📊 Business Intelligence & Analytics

### **Flexible Column Aggregation Function**
```python
def column_sum(column_index, dictionary):
    """
    Calculate the sum of any numeric column in the data structure.
    Enables rapid KPI calculation across different metrics.
    """
    return round(sum([value[column_index] for value in dictionary.values()]), 2)
```

### **Key Performance Indicators**

#### **Financial Performance Metrics**
```python
# Total revenue analysis
subtotal_sum = column_sum(2, order_dict)     # $8,731.47
tax_sum = column_sum(3, order_dict)          # $617.20  
total_revenue = column_sum(4, order_dict)    # $9,348.67

# Average transaction value
avg_transaction = round(subtotal_sum / len(order_dict), 2)  # $323.39
```

#### **Customer Behavior Analysis**
```python
# Unique customer analysis
unique_customers = len(set([order[0] for order in order_dict.values()]))  # 19 customers
orders_per_customer = round(len(order_dict) / unique_customers, 2)         # 1.42 orders/customer

# Product movement analysis  
total_items_sold = sum(len(order[6]) for order in order_dict.values())    # 54 items
```

### **Advanced Analytics: Location Performance**
```python
def aggregator(category_index, field_to_sum_index, dictionary):
    """
    Generalized function for grouping and summing data by any category.
    Enables flexible business intelligence reporting.
    """
    category_sums = {}
    for data in dictionary.values():
        category = data[category_index]
        if category not in category_sums:
            category_sums[category] = 0 
        category_sums[category] += data[field_to_sum_index]   
    return category_sums

# Revenue by location analysis
location_revenue = aggregator(5, 2, order_dict)
```

**Location Performance Results:**
- **Mammoth**: $3,879.81 (44% of revenue)
- **Stowe**: $3,582.82 (41% of revenue)  
- **Sun Valley**: $1,268.84 (15% of revenue)

---

## 📈 Business Insights & Strategic Recommendations

### **Revenue Performance Analysis**
- **Total Black Friday Revenue**: $9,348.67 across 27 orders
- **Average Transaction Value**: $323.39 (indicating premium product purchases)
- **Customer Retention**: 1.42 orders per customer (opportunity for loyalty programs)

### **Location-Based Strategy**
**Top Performers:**
1. **Mammoth** (44% share) - Premium location driving highest revenue
2. **Stowe** (41% share) - Strong performance with balanced customer base
3. **Sun Valley** (15% share) - Underperforming location requiring attention

**Strategic Recommendations:**
- **Mammoth**: Continue premium product focus and expand inventory
- **Stowe**: Maintain current strategy while exploring upselling opportunities  
- **Sun Valley**: Investigate market factors and implement targeted promotions

### **Operational Insights**
- **Peak Sales Day**: November 26th generated $5,915.18 (63% of total revenue)
- **Customer Concentration**: Top customer (C00001) generated $2,079.48 across multiple orders
- **Product Velocity**: 54 items sold with strong cross-selling evident in order data

---

## 🎓 Technical Skills Demonstrated

### **Python Programming**
- **Data Structures**: Dictionary comprehensions, list processing, nested data handling
- **String Manipulation**: Split operations, data type conversions
- **Function Design**: Reusable, parameterized functions with clear documentation
- **Error Handling**: Null value filtering and data validation

### **Excel Automation**  
- **openpyxl Mastery**: Workbook manipulation, cell addressing, data persistence
- **File I/O Operations**: Reading from and writing to Excel files programmatically
- **Data Pipeline Creation**: Automated data flow from source to processed output

### **Business Intelligence**
- **KPI Calculation**: Revenue metrics, customer analytics, performance ratios
- **Data Aggregation**: Flexible grouping functions for multi-dimensional analysis
- **Financial Modeling**: Tax calculation systems with location-based rules

### **Analytical Thinking**
- **Problem Decomposition**: Breaking complex analysis into manageable components
- **Pattern Recognition**: Identifying customer behavior and location performance trends
- **Strategic Insight**: Translating data findings into actionable business recommendations

---
---

## 🏁 Conclusion

This Black Friday analysis project showcases the power of **Python for business data processing and analysis**. By combining Excel automation with advanced data structures and analytical functions, I delivered both immediate problem-solving (missing tax calculations) and strategic business intelligence.

**Key Project Outcomes:**
- **Complete Data Pipeline**: From raw Excel data to processed business intelligence
- **Automated Tax System**: Location-aware calculations ensuring compliance and accuracy  
- **Flexible Analytics Framework**: Reusable functions enabling ongoing business analysis
- **Strategic Insights**: Data-driven recommendations for location optimization and customer retention

The project demonstrates solid knowledge in **Python programming, Excel automation, financial modeling, and business intelligence** - essential skills for modern data-driven organizations. The combination of technical execution and business insight delivery makes this a comprehensive example of data analysis in retail operations.

Sally Snow now has both the complete dataset she needed and a powerful analytical framework for future sales performance analysis, positioning Maven Ski Shop for data-driven decision making in their competitive retail environment.

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/milosilic2704/ProjectPorfolio/blob/main/Python_Portfolio/Black_Friday_Excel_data/milos_maven_ski_shop_analysis.ipynb)**  
**📊 [Back to Python Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/Python_Portfolio)**

</div>
