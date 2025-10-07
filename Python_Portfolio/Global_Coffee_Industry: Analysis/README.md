# ☕ Global Coffee Industry: Deep Dive Analysis for Strategic Market Entry

<div align="center">

![Python](https://img.shields.io/badge/Python-Intermediate-blue?style=for-the-badge&logo=python)
![Matplotlib](https://img.shields.io/badge/Matplotlib-Intermediate-orange?style=for-the-badge)
![Data Visualization](https://img.shields.io/badge/Data%20Visualization-Advanced-green?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐-yellow?style=for-the-badge)


</div>

---

## 📋 Executive Summary

**Project Type**: Client-Facing Market Intelligence & Visualization Analysis  
**Technology Stack**: Python, Pandas, Matplotlib, NumPy  
**Industry**: Commodity Trading & Agriculture  
**Time Horizon**: 28-year longitudinal study (1990-2018)  
**Client Objective**: Market entry strategy for coffee trading with focus on Brazil

**The Challenge**: A major coffee trader sought independent market intelligence to evaluate Brazil's coffee production position relative to global competitors, identify market diversification opportunities, and understand price-consumption relationships across import markets.

**The Solution**: Comprehensive multi-dimensional analysis combining production trends, market share evolution, competitive positioning, and price-demand relationships through executive-ready data visualizations designed for strategic decision-making.

---

## 🎯 Client Requirements & Project Objectives

### **Strategic Business Questions**

**From Sarah Shark, Managing Director:**
> *"We just got an inquiry from a major coffee trader looking to get an outside view on the coffee industry. They're particularly interested in Brazil's production relative to other nations. We'll also look at a comparison of importer volume vs the prices they pay to understand if we can unlock margin by diversifying into new markets."*

### **Analysis Framework**
1. **🌍 Global Market Leadership** - Identify and benchmark top coffee producing nations
2. **📈 Historical Trends** - Track production evolution of market leaders (1990-2018)
3. **🇧🇷 Brazil Market Position** - Quantify Brazil's share and competitive dynamics
4. **⚖️ Competitive Relationships** - Analyze production correlations between major players
5. **💰 Price-Demand Analytics** - Evaluate margin opportunities across import markets

---

## 🛠️ Technical Implementation

### **Phase 1: Global Production Leadership Analysis**

#### **Top 10 Coffee Producers Ranking**
```python
import pandas as pd
import matplotlib.pyplot as plt

# Load and prepare production data
coffee_production = pd.read_csv("total-production.csv").T
coffee_production.columns = coffee_production.iloc[0]
coffee_production = coffee_production.drop("total_production")

# Strategic ranking of global leaders
top10_producers = (coffee_production
    .sum()
    .sort_values(ascending=False)
    .head(10)
)
```

**Visualization Strategy**: Horizontal bar chart with two-letter country codes for executive clarity

```python
ax.set_title('Top Coffee Producing Nations 1990-2018')
ax.set_ylabel('Total Production (in 60kg bags)')
ax.set_xlabel('Country')

ax.bar(
    top10_producers.index,
    top10_producers.values
)

ax.set_xticklabels(([label[:2].upper() for label in top10_producers.index]))
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.show()
```
<img width="567" height="453" alt="image" src="https://github.com/user-attachments/assets/066854ed-caf6-4119-8917-0021e8a6fc6e" />



**Key Finding**: **Brazil dominates** with 1.19M bags total production (nearly 3x second-place Vietnam's 439K bags)

---

### **Phase 2: Temporal Market Evolution (1990-2018)**

#### **Top 5 Producers Historical Analysis**
```python
# Identify consistent market leaders
top5_countries = (coffee_production
    .sum()
    .sort_values(ascending=False)
    .head(5)
    .index
)

# Extract time-series data for visualization
top5 = coffee_production[top5_countries]
```

**Advanced Visualization**: Multi-line chart with custom title highlighting strategic insight

```python
fig, ax = plt.subplots(figsize=(8,6))

fig.suptitle("Top Coffee Producing Nations 1990-2018", fontsize=14)

ax.set_title("Viet Nam Surges to Number 2 Spot")
ax.set_ylabel('Total Production (in 60kg bags)')
ax.set_xlabel('Year')

ax.plot(
    top5.index,
    top5[['Brazil', 'Viet Nam', 'Colombia', 'Indonesia', 'Ethiopia']]
)
ax.spines[['top', 'right']].set_visible(False)

years = top5.index[::2]
ax.set_xticks(years)

ax.legend(top5.columns)

plt.show()
```

<img width="713" height="585" alt="image" src="https://github.com/user-attachments/assets/f05f5b31-904d-42a6-9aa5-df53566a4374" />


**Strategic Insight**: **Vietnam's meteoric rise** to #2 position, surging from minimal production (1,310 bags in 1990) to 31,000+ bags by 2018 - a **2,300% increase** representing major market disruption.

---

### **Phase 3: Brazil Market Share Analysis**

#### **Composition Over Time - Stacked Area Chart**
```python
# Isolate Brazil vs. rest of world
brazil = coffee_production[['Brazil']]
rest_of_world = coffee_production.drop(columns=['Brazil']).sum(axis=1)

# Create comparative dataset
brazil_vs_others = pd.concat([brazil, rest_of_world], axis=1)

# Advanced stacked area visualization
brazil_numeric = brazil_vs_others['Brazil'].astype(float)
rest_of_world_numeric = brazil_vs_others['rest_of_world'].astype(float)

ax.stackplot(
    brazil_vs_others.index,
    brazil_numeric,
    rest_of_world_numeric,
    labels=['Brazil', 'World Total'],
    colors=['#E66B14', '#99A4C4']
)
```
<img width="601" height="480" alt="image" src="https://github.com/user-attachments/assets/d55c740c-2e1f-4d54-aaf6-4430eb20661f" />


**Market Intelligence Results:**
- **1990**: Brazil held 29% global market share
- **2018**: Brazil expanded to 37% market share
- **Trend**: +8 percentage points over 28 years despite global market growth

**Strategic Implication**: Brazil not only maintained dominance but **increased market concentration** while total global production expanded significantly.

---

### **Phase 4: Competitive Production Relationships**

#### **Scatter Plot Analysis: Brazil vs. Competitors**
```python
# Correlation analysis for strategic insights
fig, ax = plt.subplots()

ax.scatter(
    coffee_production['Brazil'].astype(float),
    coffee_production['Venezuela'].astype(float),
    alpha=0.7
)

ax.set_title("Brazil and Venezuela Production")
ax.set_xlabel('Brazilian Production in Millions (60kg bags)')
ax.set_ylabel('Venezuela Production in Millions (60kg bags)')
```
<img width="580" height="453" alt="image" src="https://github.com/user-attachments/assets/0d9d7bac-1a78-4f0f-a4a0-b757e999c118" />

<img width="589" height="453" alt="image" src="https://github.com/user-attachments/assets/6f68c864-35e2-4135-8201-c0b4cc661240" />



**Analysis Findings:**
- **Brazil-Venezuela**: Inverse relationship - as Brazil grows, Venezuela declines
- **Brazil-Vietnam**: Independent growth trajectories - no correlation

**Strategic Interpretation**: Venezuela represents potential acquisition/partnership opportunity as declining producer; Vietnam represents competitive threat requiring monitoring.

---

### **Phase 5: Market Share Visualization Evolution**

#### **Historical Comparison: 1990 vs 2018**
```python
# 1990 Market Composition
ax.pie(
    brazil_vs_others.loc['1990'].sort_values(ascending=False),
    startangle=90,
    labels=["", ""],
    pctdistance=0.85,
    colors=['White', 'Blue']
)

# Custom center text showing Brazil's 29% share
plt.text(0, 0, f"{brazil_vs_others.loc['1990', 'Brazil'] / brazil_vs_others.loc['1990'].sum() * 100:.0f}%",
         horizontalalignment='center',
         verticalalignment='center',
         fontsize=50,
         color='#1C0F06')
```
<img width="422" height="409" alt="image" src="https://github.com/user-attachments/assets/9f24bfc0-b53e-4436-859e-86a8312f132f" />



**2018 Market Analysis**:
- **Brazil**: 37% (dominant leader)
- **Rest of World**: 27%
- **Vietnam**: 18% (emerging powerhouse)
- **Colombia**: 8%
- **Indonesia**: 6%
- **Ethiopia**: 5%

---

### **Phase 6: Price-Demand Relationship Analysis**

#### **Dual-Axis Visualization for Margin Opportunities**
```python
# Load consumption and pricing data
consumption = pd.read_csv("imports.csv").set_index('imports').mean(axis=1)
prices = pd.read_csv("retail-prices.csv").set_index('retail_prices').mean(axis=1)

# Advanced dual-axis bar chart
fig, ax = plt.subplots(figsize=(14,10))
width = 0.4

bar1 = ax.bar(x-width/2, price_cons['Imports'], width=width)
ax2 = ax.twinx()
bar2 = ax2.bar(x+width/2, price_cons['Price'], width=width, color='orange')

ax.set_ylabel('Imports (in 60kg bags)', fontsize=12)
ax2.set_ylabel('Average Price Paid Per Bag (USD)', fontsize=12)
ax.legend([bar1, bar2], ['Consumption', 'Price'])
```
<img width="1227" height="834" alt="image" src="https://github.com/user-attachments/assets/540d2c4f-ddee-4f29-8c9d-b180fb395707" />


---
## 🎓 Advanced Visualization Skills Demonstrated

### **Chart Type Mastery**
- **Horizontal Bar Charts** - Executive-friendly country rankings
- **Multi-Line Charts** - Temporal trend analysis with custom legends
- **Stacked Area Charts** - Market share composition evolution
- **Scatter Plots** - Competitive relationship analysis
- **Pie Charts** - Market share visualization with custom annotations
- **Dual-Axis Bar Charts** - Price-demand relationship mapping

---

## 🏁 Executive Summary & Client Deliverables

This comprehensive coffee industry analysis provides **Maven Consulting Group's client with actionable intelligence** for strategic market entry in global coffee trading.

**Key Strategic Recommendations:**

1. **Establish Primary Sourcing** from Brazil (37% market share, proven reliability)
2. **Diversify with Vietnam** partnerships (2,300% growth, competitive pricing)
3. **Target Premium Markets** in Belgium ($21.50/bag) and Japan ($21.00/bag)
4. **Build Volume** through Germany entry (16,400 bags annual consumption)
5. **Monitor Competitive Dynamics** - Vietnam growth vs Colombia stability

**Investment Thesis Validation:**
- **Brazil dominance stable and growing** (29% → 37% share over 28 years)
- **Premium margin opportunities identified** (Belgium, Japan markets)
- **Diversification paths mapped** (Vietnam sourcing, multiple sales markets)
- **Risk factors quantified** (Venezuelan decline, competitive pressures)

**Professional Deliverables:**
The analysis includes **9 executive-ready visualizations** communicating complex market dynamics through clear, actionable charts suitable for board-level presentations and strategic planning sessions.

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/milosilic2704/ProjectPorfolio/blob/main/Python_Portfolio/Global_Coffee_Industry%3A%20Analysis/Milos_Coffee_Project_Part1.ipynb)**  
**📊 [Back to Python Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/Python_Portfolio)**

</div>
