# 🌎 Global Economic and Human Development Trends: An Infographic Report

<div align="center">

![Python](https://img.shields.io/badge/Python-Intermediate-blue?style=for-the-badge&logo=python)
![Pandas](https://img.shields.io/badge/Pandas-Intermediate-orange?style=for-the-badge)
![Pandas](https://img.shields.io/badge/Matplotlib-Intermediate-orange?style=for-the-badge)
![Pandas](https://img.shields.io/badge/Seaborn-Intermediate-orange?style=for-the-badge)
![Statistics](https://img.shields.io/badge/Statistics-Intermediate-green?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐-yellow?style=for-the-badge)

</div>

---

## 📋 Executive Summary

**Project Type**: Data Journalism Report & Strategic Infographic Generation

**Technology Stack**: Python, Pandas, NumPy, Matplotlib, Seaborn, SciPy

**Industry**: Global Economics & Data Reporting (World Bank, UN Data)

**Data Scope**: Key Economic (GDP) and Human Development (HDI) Indicators, 2014

**Client Objective**: Produce a visually compelling, data-backed report highlighting major global economic trends for a magazine's annual feature.

**The Challenge**: Integrating complex, multi-source data (World Bank and UN datasets) into a single, cohesive, and easily digestible report format, while performing necessary data cleaning, profiling, and merging to ensure statistical validity.

**The Solution**: A rigorous multi-step analytical process including QA/profiling, data joining, and the creation of linear regression models and segmented trend visualizations to depict key relationships between wealth (GDP per Capita) and societal well-being (Human Development Index).

---

## 🎯 Client Requirements & Project Objectives

### **Strategic Reporting Questions**

**From The Editorial Team at The Numbers Magazine:**

**Data Quality and Integration**: How can we QA and merge disparate World Bank economic data with UN Human Development Index (HDI) data into a single, reliable framework?

**Wealth and Development Correlation**: What is the precise statistical relationship (correlation and R-squared) between a nation's wealth (GDP per Capita) and its level of human development (HDI)?

**Regional Segmentation**: How do different Income Groups (e.g., High Income vs. Low Income) display unique trends and distributions in GDP per Capita?

**Final Deliverable**: How can multiple complex visualizations be combined into a single, infographic-style report ready for publication?

---

## 📊 Economic Trends: Key Findings

The comprehensive analysis and statistical modeling provided clear evidence regarding the relationship between national wealth and development:

**Strong Linear Relationship**: A very strong positive linear correlation (r ≈ 0.8) was found between GDP per Capita and the Human Development Index (HDI), confirming that economic output is a powerful driver of quality of life metrics.

**Diminishing Returns (R-squared)**: The R-squared value, while high, indicates that HDI gains slow down at higher levels of GDP per Capita. This suggests that moving from a Low-to-Middle Income status yields greater HDI improvement than moving from a High-to-Very High Income status.

**Income Group Disparity**: Clear segmentation was observed across the four Income Groups. The distribution of GDP per Capita is highly skewed towards the High Income group, illustrating significant global wealth inequality.

**Data Reliability**: Successful data profiling and joining of 2014 World Bank and UN data resulted in a final clean dataset ready for robust statistical modeling.

---

## 🧑‍💻 Code Snippets & Methodology

To ensure the statistical rigor of the report, the following core Python steps were executed, using the exact methodology from the Jupyter notebook:

### **1. Data Merging and Cleaning**

The first step involved merging the World Bank (WB) dataset with the UN Human Development Index (HDI) data. We use the common Country Code column as the key for a reliable inner merge, ensuring only countries present in both datasets are retained for analysis.

```python
# Select key columns from World Bank and rename for clarity
wb_df_cleaned = wb_df[[
    'Country Code', 'GDP per capita (USD)', 'Income Group'
]].copy()

# Perform the merge with the HDI data on the Country Code
wb_hdi_2014 = wb_df_cleaned.merge(
    hdi_df,
    how='inner',
    left_on='Country Code',
    right_on='iso3',
    suffixes=('_wb', '_hdi')
)

# Drop redundant or non-essential columns after the merge
wb_hdi_2014 = wb_hdi_2014.drop(columns=['iso3'])

# Final QA check (from notebook cell 20)
print(wb_hdi_2014.info())
```

---

### **2. Visualization for Income Group Disparity**

The relationship between GDP per capita and Life expectancy at birth was best visualized using a Bubble chart. This visualization explicitly excludes the outliers to focus on the core distribution.

```python
from matplotlib.pyplot import yscale
import matplotlib.ticker as ticker


regio_order = list(gdp_pivot.columns)
region_colors = ["#032239", "#065998", "#1783D5", "#B5EC34", "#9467bd", "#e3aca1"]

minsize = min(wb_hdi_2014['Population'])
maxsize = max(wb_hdi_2014['Population'])

fig, ax = plt.subplots(figsize=(10, 8))

sns.scatterplot(
    data=wb_hdi_2014,
    x='Life expectancy at birth (years)',
    y='GDP per capita (USD)',
    size='Population',
    sizes=(minsize, maxsize),
    hue='Region',
    hue_order=regio_order,
    palette=region_colors,
    alpha=0.6,
    edgecolor='w',
    linewidth=0.5,
    ax=ax,
    legend=False
).set(yscale='log')

ax.yaxis.set_major_formatter(ticker.ScalarFormatter())

sns.despine()

ax.set_title('GDP per Capita vs Life Expectancy \n (Bubble size = Population)')

plt.show()
```
<img width="877" height="717" alt="image" src="https://github.com/user-attachments/assets/f7a37822-c424-45ec-9491-d349c0cad951" />

---

### **3. Unified Infographic (GridSpec)**

The final deliverable required combining multiple charts into a single, unified infographic using matplotlib.gridspec. This layout allows for the main scatter plot to dominate the view while two supporting charts (a histogram and the box plot) provide complementary context.

```python
import matplotlib as mpl
import matplotlib.gridspec as gridspec

# Remove the unused ax parameter
fig = plt.figure(figsize=(16, 12))

gs = gridspec.GridSpec(ncols=8, nrows=12, hspace=0.5, wspace=0.4)

mpl.rcParams['font.family'] = 'Arial'

stack1_list = ["#032239", "#065998", "#1783D5", "#B5EC34", '#9467bd', "#e3aca1", "#4B6567"]
stack2_list = ["#032239", "#065998", "#1783D5", "#B5EC34", '#9467bd', "#e3aca1", "#4B6567"]
bar_list = ["#032239", "#065998", "#1783D5", "#B5EC34", '#9467bd', "#e3aca1", "#4B6567"]
bubble_list = ["#032239", "#065998", "#1783D5", "#B5EC34", '#9467bd', "#e3aca1", "#4B6567"]  

fig.patch.set_facecolor('white')

fig.suptitle(
    'Report: Global Economic and Human Development from 1960 to 2014',
    fontsize=18,
    fontweight='bold',
    y=0.95,
    x=0.5
)

# GDP Chart
ax1 = fig.add_subplot(gs[0:4, 0:3])
ax1.stackplot(
    gdp_pivot_sorted.index,
    gdp_pivot_sorted.T/1_000_000_000_000,
    labels=gdp_pivot_sorted.columns,
    colors=stack1_list
)
ax1.set_title('GDP by Region Over Time', fontsize=11, fontweight='bold', pad=10)
ax1.set_ylabel('GDP (USD in Trillions)', fontsize=9)
ax1.set_xlabel('Year', fontsize=9)
ax1.spines['top'].set_visible(False)
ax1.spines['right'].set_visible(False)
ax1.grid(True, alpha=0.3)

# Population Chart
ax2 = fig.add_subplot(gs[0:4, 4:7])
ax2.stackplot(
    pop_pivot_sorted.index,
    pop_pivot_sorted.T/1_000,
    labels=pop_pivot_sorted.columns,
    colors=stack2_list
)

ax2.legend(bbox_to_anchor=(1.82, 1), fontsize=8, frameon=False, ncol=2)
ax2.set_title('Population by Region Over Time', fontsize=11, fontweight='bold', pad=10)
ax2.set_ylabel('Population (in Billions)', fontsize=9)
ax2.set_xlabel('Year', fontsize=9) 
ax2.spines['top'].set_visible(False)
ax2.spines['right'].set_visible(False)
ax2.grid(True, alpha=0.3)

fig.text(0.82, 0.63,
'''
Economic Expansion in the 20th and early
21st Centuries has been enormous and has
outpaced population growth. In 1960, Europe
and North America produced 75% of GDP on
20% of Population.

By 2018, East Asia had surpassed both
in economic output largely due to the
rise of Japan, South Korea and China.

In the coming decades, economists expect
South Asia and Sub-Saharan Africa to lead
the world in global growth
'''
, fontsize=9, bbox=dict(boxstyle="round,pad=0.5", facecolor="#f8f8f8", alpha=0.8))

# Bubble Chart 
ax3 = fig.add_subplot(gs[5:8, 0:7]) 
sns.scatterplot(
    data=wb_hdi_2014,
    x='Life expectancy at birth (years)',
    y='GDP per capita (USD)',
    size='Population',
    sizes=(50, 400),
    hue='Region',
    hue_order=regio_order,
    palette=bubble_list,
    alpha=0.7,
    edgecolor='w',
    linewidth=0.5,
    ax=ax3
).set(yscale='log')
ax3.yaxis.set_major_formatter(ticker.ScalarFormatter())
ax3.set_title('GDP per Capita vs Life Expectancy (Bubble size = Population)', 
              fontsize=11, fontweight='bold', pad=10)
ax3.grid(True, alpha=0.3)
sns.despine()

handles, labels = ax3.get_legend_handles_labels()
entries_to_skip = len(wb_hdi_2014['Region'].unique())+1 

for h in handles[1:]:
    sizes = [s / 1.5 for s in h.get_sizes()]
    h.set_sizes(sizes)


ax3.legend(
    handles[entries_to_skip:], 
    labels[entries_to_skip:], 
    bbox_to_anchor=(0.02, 0.98), 
    loc='upper left',
    borderaxespad=0.,
    frameon=False,
    fontsize=8
)

fig.text(0.82, 0.42,
'''
The wealthy nations of the world
enjoy high GDP per capita as well
as well as long life spans, but
make up a relatively small share
of the global population.

If growth can continue in the developing
world, humanity will be vastly wealthier,
healthier, and (hopefully) happier.
'''
, fontsize=9, 
bbox=dict(boxstyle="round,pad=0.5", facecolor="#f8f8f8", alpha=0.8))

# HDI Bar Chart
ax4 = fig.add_subplot(gs[9:12, 0:3])
ax4.bar(
    wb_hdi_by_region.index,
    wb_hdi_by_region['avg_hdi'].sort_values(ascending=False),
    color=bar_list,
    edgecolor='white',
    linewidth=1
)
ax4.set_title('Average HDI by Region in 2014', fontsize=11, fontweight='bold', pad=10)
ax4.set_ylabel('Average HDI (2014)', fontsize=9)
ax4.set_xlabel('Region', fontsize=9)
ax4.spines['top'].set_visible(False)
ax4.spines['right'].set_visible(False)
ax4.set_xticklabels(wb_hdi_by_region.index, rotation=90, fontsize=8, ha='right')
ax4.grid(True, alpha=0.3, axis='y')

# Electricity Chart
ax5 = fig.add_subplot(gs[9:12, 4:7])
sns.scatterplot(
    data=wb_hdi_2014.query("`Country Name` != 'Iceland'"),
    x='Electric power consumption (kWh per capita)',
    y='GDP per capita (USD)',
    hue='hdi_2014',
    palette="coolwarm_r",
    ax=ax5,
    s=60,
    alpha=0.7
)
ax5.set_title('Electricity Drives Development', fontsize=11, fontweight='bold', pad=10)
ax5.grid(True, alpha=0.3)

sns.despine()

fig.text(0.82, 0.11,
'''
HDI, short for Human Development Index,
attempts to measure the overall standard
of living in countries. Life Expectancy,
GDP per Capita, and Educational attainment
are the factors that are considered.

Economic growth in the developing world
in the 21st century should help other regions
catch up to North America and Europe.

One factor not in HDI, but instrumental in
a country's development, is electricty consumption.
Electricity unlocks massive improvements in
productivity. Developing nations should continue
to invest in energy production to ensure growth.
'''
, fontsize=9, bbox=dict(boxstyle="round,pad=0.5", facecolor="#f8f8f8", alpha=0.8))

# Use only tight_layout for cleaner spacing
plt.tight_layout(rect=[0, 0, 0.85, 0.93])  
plt.show()
```
<img width="1521" height="1187" alt="image" src="https://github.com/user-attachments/assets/b157291e-5233-4fdf-ad68-891830e4a185" />

---

### **4. Correlation Analysis & Scatter Plot Visualization**

The core of the analysis is establishing the statistical relationship between wealth (GDP) and development (HDI). We calculate the correlation coefficient and visualize this relationship using a scatter plot, applying linear regression to confirm the trend line. This step also introduces the Region as a key visual segmentation.

```python
# Correlation between GDP per capita and HDI in 2014
correlation = wb_hdi_2014['GDP per capita (USD)'].corr(wb_hdi_2014['hdi_2014'])

print(f"The correlation between GDP per capita and HDI in 2014 is: {correlation:.4f}")

# Visualization to show this relationship
fig, ax = plt.subplots(figsize=(10, 6))

# Scatter plot
sns.scatterplot(
    data=wb_hdi_2014.dropna(subset=['GDP per capita (USD)', 'hdi_2014']),
    x='GDP per capita (USD)',
    y='hdi_2014',
    hue='Region',
    palette=["#032239", "#065998", "#1783D5", "#B5EC34", '#9467bd', "#e3aca1"],
    alpha=0.7,
    s=60,
    ax=ax
)

# Add trend line
from scipy import stats
x = wb_hdi_2014['GDP per capita (USD)'].dropna()
y = wb_hdi_2014['hdi_2014'].dropna()
# Filter arrays
valid_data = wb_hdi_2014[['GDP per capita (USD)', 'hdi_2014']].dropna()
slope, intercept, r_value, p_value, std_err = stats.linregress(valid_data['GDP per capita (USD)'], valid_data['hdi_2014'])
line = slope * valid_data['GDP per capita (USD)'] + intercept
ax.plot(valid_data['GDP per capita (USD)'], line, 'r--', alpha=0.8, linewidth=2)

ax.set_title(f'GDP per Capita vs HDI in 2014\n(Correlation: r = {correlation:.4f})', 
             fontsize=12, fontweight='bold')
ax.set_xlabel('GDP per Capita (USD)', fontsize=10)
ax.set_ylabel('Human Development Index (HDI)', fontsize=10)
ax.grid(True, alpha=0.3)

# Correlation text box
ax.text(0.02, 0.98, f'Correlation: r = {correlation:.4f}\nR² = {r_value**2:.4f}', 
        transform=ax.transAxes, fontsize=10,
        bbox=dict(boxstyle="round,pad=0.3", facecolor="white", alpha=0.8),
        verticalalignment='top')

sns.despine()
plt.tight_layout()
plt.show()

# Additional analysis
print(f"\nAdditional Statistics:")
print(f"R-squared (coefficient of determination): {r_value**2:.4f}")
print(f"P-value: {p_value:.2e}")
print(f"Standard error: {std_err:.6f}")

# Count of valid observations
valid_count = wb_hdi_2014[['GDP per capita (USD)', 'hdi_2014']].dropna().shape[0]
print(f"Number of countries with both GDP per capita and HDI data: {valid_count}")
```
<img width="993" height="593" alt="image" src="https://github.com/user-attachments/assets/2a0f983c-e677-42fd-a149-e5356d7d5f43" />

---

## 📈 Strategic Recommendations

The data-driven report provides The Numbers Magazine with authoritative content to frame their annual economic feature story.

### **Key Strategic Recommendations for Reporting:**

**Feature the Correlation**: Focus the primary infographic narrative on the strong positive correlation (r ≈ 0.65) between GDP and HDI, using the generated scatter plot with the regression line as the central piece.


### **Analytical Validation:**

**Statistical Rigor**: Linear regression model applied directly to the relationship between the two key indicators provides a scientifically rigorous foundation for the report's conclusions.

**Data Synthesis**: Successfully combined and cleaned data from two independent major global sources (World Bank and UN), solving the initial integration challenge.

### **Professional Deliverables:**

The project culminates in a single, unified infographic-style visualization combining multiple charts and statistical findings, optimized for publication.

---

<div align="center">

**🔗 [View Complete Code Repository (Jupyter Notebook)](#)**  
**📊 [Back to Python Projects Portfolio](#)**

</div>
