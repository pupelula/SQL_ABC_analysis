# 🔍Что такое ABC анализ?
Это метод, используемый в управлении запасами для классификации товаров или клиентов в зависимости от их важности и степени вклада в результат компании.

**Группа А:** важные товары, которые вносят значительный вклад в доход или составляют большую часть стоимости запасов. Обычно они требуют тщательного мониторинга и жесткого контроля. 

**Группа B:** это товары средней важности. Они требуют регулярного мониторинга и управления.

**Группа С:** эти товары оказывают минимальное влияние на доход или стоимость запасов. Обычно они имеют более низкий приоритет для управления. Часто это претенденты на исключение из ассортимента или новые товары.

Оптимизируя управление запасами и распределение ресурсов, анализ ABC помогает компаниям повысить эффективность и принимать более обоснованные решения при ограниченных ресурсах. 

# 💾Исходные данные

Таблица **list_of_orders**
 - order_id
 - order_date
 - customer_name
 - state
    
Таблица **order_details**
 - order_id
 - amount
 - profit
 - quantity
 - category
 - sub_category

# ✏Анализ данных
Для начала соединим две таблиыц и создадим набор данных с информацией об общей прибыли для каждой подкатегории.
```javascript
WITH profit_by_sub_category AS
(SELECT sub_category, SUM(profit) AS sub_category_profit
FROM 
list_of_orders
INNER JOIN order_details 
USING (order_id)
GROUP BY sub_category),
