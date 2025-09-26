# 📊 Maven MegaMart: Advanced Customer Behavior & Demographic Analytics

<div align="center">

![Python](https://img.shields.io/badge/Python-Intermediate-blue?style=for-the-badge&logo=python)
![Pandas](https://img.shields.io/badge/Pandas-Intermediate-green?style=for-the-badge&logo=pandas)
![Customer Analytics](https://img.shields.io/badge/Customer%20Analytics-Expert-purple?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐-yellow?style=for-the-badge)

</div>

---

## 📋 Project Overview

**Project Type**: Customer Behavior & Demographic Segmentation Analysis  
**Technology Stack**: Python, Pandas, NumPy  
**Industry**: Retail Analytics  
**Skill Level**: Intermediate
**Data Scale**: Multi-dimensional customer transaction dataset

**The Challenge**: Maven MegaMart needed deep insights into customer behavior patterns to optimize marketing strategies, improve inventory management, and enhance customer experience across different demographic segments.

**The Solution**: Developed a comprehensive customer analytics framework combining transaction data, demographic profiles, and product information to deliver actionable insights on seasonal trends, customer segmentation, and department-specific performance by age groups.

---

## 🎯 Project Objectives

### **Strategic Business Goals**
1. **📈 Temporal Analysis** - Understand sales trends over time and identify seasonal patterns
2. **👥 Demographic Segmentation** - Analyze customer behavior across age, income, and household composition
3. **🛒 Product Intelligence** - Determine department preferences by demographic groups
4. **📊 Customer Value Analysis** - Identify highest-value customer segments for targeted marketing
5. **🎯 Strategic Recommendations** - Provide data-driven insights for business optimization

### **Technical Deliverables**
- Time-series analysis of sales performance
- Multi-dimensional customer segmentation
- Department performance analysis by demographics
- Customer value profiling and insights
- Executive-ready reporting and visualizations

---

## 🛠️ Technical Implementation

### **Phase 1: Data Infrastructure & Optimization**

#### **Advanced Data Loading & Memory Optimization**
```python
import pandas as pd
import numpy as np

# Strategic column selection for focused analysis
transactions = pd.read_csv(
    'project_transactions.csv',
    usecols=['household_key', 'BASKET_ID', 'DAY', 'PRODUCT_ID', 'QUANTITY', 'SALES_VALUE']
)

# Memory optimization for enterprise-scale processing
transactions = transactions.astype({
    'DAY': 'int16',
    'QUANTITY': 'int32', 
    'PRODUCT_ID': 'int32',
})

# Advanced date transformation for time-series analysis
transactions = (
    transactions
    .assign(date = (pd.to_datetime("2016", format='%Y') 
                    + pd.to_timedelta(transactions["DAY"].sub(1).astype(str) + " days"))
           )
    .drop(["DAY"], axis=1)
)
```

**Technical Achievement**: Optimized data types and transformed raw day numbers into proper datetime objects for sophisticated time-series analysis capabilities.

---

### **Phase 2: Time-Based Business Intelligence**

#### **Seasonal Trends & Pattern Recognition**
The analysis revealed critical temporal insights for strategic planning:

**Monthly Sales Consistency**: Sales patterns showed remarkable consistency between 2016 and 2017, indicating stable customer behavior and predictable revenue streams.

**Weekend Shopping Dominance**: 
- **Saturday & Sunday**: Highest sales volume
- **Friday**: Third-highest, indicating weekend preparation shopping
- **Weekday Pattern**: Lower but consistent mid-week performance

**Strategic Value**: These patterns enable optimized staffing, inventory management, and promotional timing for maximum impact.

---

### **Phase 3: Advanced Demographic Analytics**

#### **Multi-Dimensional Customer Segmentation**
```python
# Strategic demographic data integration
demographics = pd.read_csv(
    'hh_demographic.csv',
    usecols=['AGE_DESC', 'INCOME_DESC', 'household_key', 'HH_COMP_DESC']
).astype({
    'AGE_DESC': 'category',
    'INCOME_DESC': 'category', 
    'HH_COMP_DESC': 'category'
})

# Customer value aggregation
hh_sales = transactions.groupby('household_key').agg({'SALES_VALUE': 'sum'})

# Strategic data integration for comprehensive customer profiling
demographics_with_sales = demographics.merge(
    hh_sales,
    how='inner',
    on='household_key'
)
```

#### **Customer Value Matrix Analysis**

**High-Value Demographic Insights:**

| Age Group | Household Type | Average Sales | Strategic Insight |
|-----------|---------------|---------------|-------------------|
| **55-64** | Unknown | **$7,973.80** | Premium mysterious segment |
| **25-34** | Unknown | **$7,356.30** | High-value younger demographic |
| **35-44** | 2 Adults Kids | **$6,691.80** | Family powerhouse segment |
| **45-54** | 1 Adult Kids | **$6,632.60** | Single-parent high spenders |

**Strategic Recommendations:**
- **Target 55-64 "Unknown"**: Investigate this high-value mysterious segment for expansion opportunities
- **Family Focus**: "2 Adults Kids" across multiple age groups show consistent high spending
- **Single Parent Strategy**: "1 Adult Kids" segments demonstrate significant purchasing power

---

### **Phase 4: Product Department Intelligence**

#### **Advanced Multi-Dataset Integration**
```python
# Complete product intelligence framework
products = pd.read_csv(
    'product.csv',
    usecols=['PRODUCT_ID', 'DEPARTMENT']
).astype({'DEPARTMENT': 'category'})

# Strategic data consolidation
products_with_transactions = products.merge(
    transactions,
    how='inner',
    on='PRODUCT_ID'
)

final_table = products_with_transactions.merge(
    demographics,
    how='inner', 
    on='household_key'
)
```

#### **Department Performance by Age Segment**

**Young Adult Market Analysis (19-24):**

| Department | Sales Volume | Strategic Positioning |
|------------|-------------|----------------------|
| **GROCERY** | $99,008.27 | Essential daily needs dominance |
| **DRUG GM** | $25,297.43 | Health & wellness focus |
| **MEAT** | $11,957.34 | Fresh food preference |
| **KIOSK-GAS** | $8,465.18 | Convenience & mobility |

**Cross-Age Department Intelligence:**
- **GROCERY**: Consistent leader across all demographics ($99K-$667K range)
- **DRUG GM**: Strong secondary performance in all age groups  
- **MEAT**: Significant fresh food market across demographics
- **KIOSK-GAS**: Convenience category with steady performance

---

## 📈 Strategic Business Insights

### **Customer Segmentation Strategy**

#### **High-Value Target Segments**
1. **"Unknown 55-64"** - $7,973 average: Mystery high-spenders requiring investigation
2. **"Unknown 25-34"** - $7,356 average: Young professionals with premium spending
3. **"Family Units"** - $6,200+ average: Households with children across age groups
4. **"Single Parents"** - $6,600+ average: High-value single-adult-with-kids segments

#### **Temporal Optimization Opportunities**
- **Weekend Focus**: 60%+ of sales on Saturday/Sunday suggest weekend-centric marketing
- **Seasonal Consistency**: Predictable year-over-year patterns enable accurate forecasting
- **Promotional Timing**: Friday promotions could bridge weekday-weekend shopping behavior

### **Department Strategy Recommendations**

#### **Age-Specific Marketing**
- **19-24 Focus**: Grocery essentials and convenience (gas/kiosk) targeting
- **25-44 Peak**: Full-service family shopping with emphasis on fresh departments
- **45-64 Premium**: High-value segments across all departments with premium positioning
- **65+ Strategy**: Consistent but moderate spending requiring loyalty-focused approach

#### **Product Mix Optimization**
- **GROCERY**: Universal appeal requiring broad inventory and competitive pricing
- **DRUG GM**: Secondary powerhouse suggesting health/wellness expansion opportunities  
- **MEAT/PRODUCE**: Fresh food preference indicating quality and freshness priorities
- **CONVENIENCE**: Gas/kiosk services driving foot traffic and basket completion

---

## 🎓 Advanced Analytics Skills Demonstrated

### **Data Engineering Best Practice**
- **Memory Optimization**: Strategic data type selection for performance
- **Data Integration**: Complex multi-table joins across transactions, demographics, and products
- **Time-Series Processing**: Advanced date transformation and temporal analysis
- **Category Management**: Efficient categorical data handling for demographic analysis

### **Customer Analytics Mastery** 
- **Segmentation Analysis**: Multi-dimensional customer profiling and value assessment
- **Behavioral Intelligence**: Temporal pattern recognition and seasonal trend analysis
- **Value Engineering**: Customer lifetime value approximation and segment prioritization
- **Product Affinity**: Department preference analysis by demographic characteristics

### **Business Intelligence Delivery**
- **Pivot Table Mastery**: Complex multi-dimensional analysis and reporting
- **Visualization Strategy**: Clear, actionable insights for executive consumption
- **Strategic Reporting**: Executive-ready Excel deliverables for stakeholder distribution
- **Actionable Insights**: Data-driven recommendations with clear business implications

---

## 💼 Business Impact & Strategic Value

### **Customer Strategy Transformation**
- **Segment Identification**: Discovered $7,973 average spending "Unknown 55-64" segment requiring targeted research
- **Family Market Validation**: Confirmed families with children as consistent high-value customers across age groups
- **Young Professional Opportunity**: Identified $7,356 spending 25-34 "Unknown" segment for premium targeting
- **Weekend Optimization**: Data-driven confirmation of weekend shopping dominance for operational planning

### **Operational Intelligence**
- **Inventory Planning**: Department performance by age enables targeted stock optimization
- **Staffing Strategy**: Weekend sales concentration informs resource allocation decisions
- **Promotional Timing**: Seasonal consistency enables predictive marketing campaign planning
- **Store Layout**: Department preference by age supports strategic merchandising decisions

### **Revenue Optimization**
- **High-Value Targeting**: Identified specific demographic combinations generating $6,000+ annual spending
- **Department Focus**: GROCERY and DRUG GM dominance suggests expansion and premium positioning opportunities
- **Convenience Integration**: Gas/kiosk performance indicates successful foot traffic conversion strategies
- **Fresh Food Strategy**: Meat and produce performance validates quality-focused positioning

---

## 🚀 Advanced Technical Features

### **Data Processing Excellence**
```python
# Executive-ready pivot table creation
(final_table.pivot_table(
    index='DEPARTMENT',
    columns='AGE_DESC', 
    values='SALES_VALUE',
    aggfunc='sum'
)).to_excel("final_table.xlsx", sheet_name='sales_pivot')
```

**Professional Deliverables**: Automated Excel export functionality for seamless stakeholder distribution and executive reporting.

### **Analytical Framework Benefits**
- **Scalable Architecture**: Reusable analytical framework for ongoing customer intelligence
- **Multi-Dimensional Analysis**: Integrated view of time, demographics, and product performance
- **Business-Ready Outputs**: Professional Excel deliverables for immediate business application
- **Strategic Decision Support**: Data-driven insights enabling confident marketing and operational decisions

---

## 🏁 Executive Summary & Strategic Recommendations

This comprehensive customer behavior analysis reveals **Maven MegaMart's customer base demonstrates predictable patterns with significant optimization opportunities** across demographic segments and temporal behaviors.

**Key Strategic Findings:**
- **High-Value Mystery Segments**: "Unknown" demographics in 25-34 and 55-64 age groups represent premium targeting opportunities
- **Family Market Dominance**: Households with children consistently generate $6,200+ annual spending across age groups  
- **Weekend Revenue Concentration**: Saturday/Sunday dominance enables focused operational and marketing strategies
- **Department Leadership**: GROCERY and DRUG GM categories show universal appeal with expansion potential

**Implementation Priorities:**
1. **Investigate Unknown Segments**: Research high-value "Unknown" demographics for targeted acquisition strategies
2. **Family-Focused Marketing**: Develop specialized campaigns for households with children across age groups
3. **Weekend Operations Optimization**: Enhance staffing, inventory, and promotional activities for peak shopping periods
4. **Department Strategy**: Expand GROCERY and DRUG GM offerings while maintaining fresh food quality standards

The analytical framework developed provides **ongoing capability for customer intelligence**, enabling Maven MegaMart to maintain competitive advantage through data-driven customer understanding and strategic decision-making.

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/milosilic2704/ProjectPorfolio/blob/main/Python_Portfolio/Maven_MegaMart_Advanced_Customer_Behaviour/Milos_Maven_MegaMart_final_project.ipynb)**  
**📊 [Back to Python Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/Python_Portfolio)**

</div>
