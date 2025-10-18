# ☕ Brazil's Global Coffee Market Dominance: A Data-Driven Report

<div align="center">

![Python](https://img.shields.io/badge/Python-Intermediate-blue?style=for-the-badge&logo=python)
![Pandas](https://img.shields.io/badge/Pandas-Intermediate-green?style=for-the-badge&logo=pandas)
![Data Visualization](https://img.shields.io/badge/Matplotlib-Advanced-orange?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐-yellow?style=for-the-badge)

</div>

---

## 📋 Project Overview

**Client**: Clarissa Café (Coffee Industry Client)  
**Project Type**: Global Market Share & Pricing Analysis  
**Technology Stack**: Python, Pandas, Matplotlib, NumPy, Matplotlib GridSpec  
**Industry**: Coffee & Agricultural Commodities  
**Focus**: Brazil's long-term production dominance (1990–2018) and international grower price distribution.

**The Challenge**: Clarissa Café commissioned a summary report that could combine complex multi-source data into a **single-figure visual report**. This required analyzing Brazil's place in the global coffee market, specifically its production share and the distribution of prices paid to growers. The primary technical challenge was using advanced Matplotlib features like **GridSpec** and **Subplots** to create a unified, executive-ready dashboard.

**The Solution**: An advanced data visualization solution that integrated global production and grower price data, performed multi-year trend and comparative analysis, and synthesized all findings into a cohesive, branded dashboard. The report clearly communicates Brazil's surging market share and the distinct price dynamics of key producing nations.

---

## 🎯 Project Objectives

### **Analytical & Visualization Goals**
1. **📊 Global Production Share** - Analyze and visualize Brazil's production share in 1990 and 2018 using **Donut Charts**.
2. **📈 Long-Term Trend** - Compare Brazil's production against the 'Rest of the World' over time using a **Stacked Area Plot**.
3. **💰 Top Nations Comparison** - Identify and visualize the production volume of the top 5 global coffee-producing nations (including a category for 'Other').
4. **📦 Grower Price Distribution** - Analyze the distribution of prices paid to growers for Brazil, Colombia, Ethiopia, and the average for all other nations using a **2×2 Subplot Grid of Histograms**.
5. **🎨 Integrated Dashboard** - Combine all findings into one polished, multi-panel report using **Matplotlib GridSpec**.

### **Key Deliverables**
- **Executive Single-Figure Dashboard** (Meshgrid Report)
- **Time-Series Analysis** (Stack Plot)
- **Market Composition Analysis** (Bar Chart and Pie Chart)
- **Grower Price Distribution Analysis** (Subplot Histograms)

---

## 🛠️ Technical Implementation

### **Phase 1: Data Acquisition & Transformation**

Raw data from `total-production.csv` and `prices-paid-to-growers.csv` was loaded and transposed using Pandas for optimal analysis.

#### **Production Data Reshaping**

The core transformation involved calculating Brazil's production and the aggregate of the 'Other' countries to facilitate market share visualization and the Stacked Area Plot.

```python
# Load and transpose the production dataset
coffee_production = pd.read_csv("total-production.csv").T

# Calculate 'Other' category for comparative analysis
brazil_vs_others = pd.DataFrame({
    'Brazil': coffee_production['Brazil'].astype(float),
    'Other': coffee_production.drop(columns=['Brazil']).astype(float).sum(axis=1)
})

# Identify and aggregate Top 5 nations for 2018
```

#### **Grower Price Data Transformation**

The `prices-paid-to-growers.csv` file was cleaned, and a crucial 'Other Nations' column was created by taking the average price across all non-focus countries for a holistic view of the market.

```python
# Load and clean grower prices data
prices_paid_to_growers = pd.read_csv("prices-paid-to-growers.csv").T.drop(9, axis=1)

# Calculate the average price for all non-focus countries
prices_paid_to_growers["Other Nations"] = prices_paid_to_growers.drop([
    "Colombia", "Brazil", "Ethiopia"
], axis=1).mean(axis=1)
```

---

### **Phase 2: Integrated Dashboard Construction**

The analysis was consolidated into a single figure using the Matplotlib GridSpec (a **12×12 grid**) to combine six charts, including two Donut Charts, a Stack Plot, a Bar Chart, a Pie Chart, and a Text Box.

#### **Layout Strategy**

| Section | Chart Type | Data Focus |
|---------|-----------|------------|
| **Top-Left** | Text Summary | Contextual overview of Brazil's market growth |
| **Top-Center** | Donut Chart | Brazil's 29% Global Production Share in 1990 |
| **Top-Right** | Donut Chart | Brazil's 37% Global Production Share in 2018 |
| **Center** | Stacked Area Plot | Brazil's growing share versus Rest of World (1990-2018) |
| **Bottom-Left** | Horizontal Bar Chart | Total production for Top 5 Nations + Rest of World (2018) |
| **Bottom-Right** | Pie Chart | Composition of global production in 2018 |

```python
# Matplotlib GridSpec Implementation
fig = plt.figure(constrained_layout=True, figsize=(12, 10))
grid = gridspec.GridSpec(ncols=12, nrows=12, figure=fig)

# Custom color scheme applied using green for Brazil and gray for 'Other' categories
```

---

## 📊 Visual Analysis & Key Insights

### **1. Market Dominance & Growth Trajectory**

**Brazil's share of global production rose significantly from 29% in 1990 to 37% in 2018.**

The Stacked Area Plot visually demonstrates that Brazil's output surged as the global market itself expanded by over 50%, cementing its place as the top producer.

In 2018, the Top 5 producers were Brazil, Viet Nam, Colombia, Indonesia, and Ethiopia, with Brazil maintaining the clear lead.

---

### **2. Grower Price Distribution**

The **2×2 subplot grid** compares the historical distribution of prices paid to growers:

**Brazil's Wide Distribution**: The distribution of prices paid to growers in Brazil is the most dispersed, suggesting greater price volatility or a wider range of quality tiers commanding diverse prices compared to other single nations.

**Consistent Competitors**: The price distributions for Colombia, Ethiopia, and the Other Nations average are generally tighter, indicating a more concentrated historical price range.

**Strategic Business Intelligence**: The data confirms Brazil's market control and suggests that its supply can influence global market stability. The price volatility within Brazil, compared to competitors, highlights the country's diverse production capabilities, ranging from high-volume commodity to specialty-grade coffee.

---

## 🎓 Conclusion

This analysis successfully utilizes advanced Matplotlib layout techniques (Meshgrid and Subplots) and robust Pandas data preparation to deliver clear, actionable market intelligence. The single-figure report provides the client, Clarissa Café, with a high-level, data-driven synthesis of Brazil's global coffee industry standing, essential for strategic sourcing and risk management decisions.

**Project Achievements:**
- **Technical Execution**: Seamless integration of multiple visualizations into a unified 12×12 GridSpec dashboard
- **Analytical Depth**: Quantified Brazil's long-term market share growth and mapped complex grower price dynamics
- **Client Focus**: Delivered a professional, single-figure report that meets the executive communication requirements of the client

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/yourusername/brazil-coffee-analysis)**  
**📊 [Back to Python Projects Portfolio](https://github.com/yourusername/portfolio)**

</div>
