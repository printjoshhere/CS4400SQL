use restaurant_supply_express;

-- [24] display_owner_view()
SELECT * FROM restaurant_owners;
SELECT max(rating) as highs, min(rating) as lows FROM restaurants WHERE funded_by IN (SELECT username FROM restaurant_owners) GROUP BY funded_by;
-- max(rating) as highs, min(rating) as lows 

SELECT users.username, users.first_name, users.last_name, users.address, max(rating) as highs, min(rating) as lows FROM users, restaurants WHERE username IN (SELECT username FROM restaurant_owners) GROUP BY username;

SELECT COUNT(funded_by) FROM restaurants GROUP BY funded_by;
-- as num_restaurants

SELECT * FROM restaurants;
-- as num_places

-- [25] display_employee_view()
SELECT employees.username, employees.taxID, employees.salary, employees.hired, employees.experience as employee_experience, 
coalesce(pilots.licenseID, 'n/a') as licenseID, coalesce(pilots.experience, 'n/a') as piloting_experience, 
CASE WHEN delivery_services.id IS NOT NULL THEN 'yes' ELSE 'no' END AS manager_status FROM employees 
LEFT JOIN pilots ON pilots.username=employees.username 
LEFT JOIN work_for ON work_for.username=employees.username 
LEFT JOIN delivery_services ON delivery_services.manager=work_for.username;

-- [26] display_pilot_view()
SELECT * FROM pilots;
SELECT * FROM drones;

SELECT pilots.username, pilots.licenseID, pilots.experience, COUNT(flown_by) as num_drones, COUNT(distinct hover) as num_locations FROM pilots LEFT JOIN drones ON drones.flown_by=pilots.username GROUP BY pilots.username;
-- Note, we have to account for all drones (might not be flown directly, but in a swarm)
-- TODO: num_drones
SELECT * FROM drones WHERE swarm_tag IN (SELECT tag FROM drones WHERE flown_by='fprefontaine6');
-- GROUP BY swarm

-- [27] display_location_view()
SELECT locations.label, locations.x_coord, locations.y_coord, COUNT(restaurants.location) as num_restaurants, COUNT(delivery_services.home_base) as delivery_services FROM locations
LEFT JOIN restaurants ON restaurants.location=locations.label
LEFT JOIN delivery_services ON delivery_services.home_base=locations.label GROUP BY locations.label; 

SELECT * FROM locations;
SELECT * FROM restaurants;
SELECT * FROM delivery_services;
SELECT * FROM drones;

-- [28] display_ingredient_view()
SELECT * FROM ingredients;
SELECT * FROM payload;
SELECT * FROM drones;
-- drones.hover as location, payload.quantity as amount_available
-- min(payload.price) as low_price, max(payload.price) as high_price
SELECT ingredients.iname as ingredient_name, payload.quantity FROM ingredients LEFT JOIN payload ON payload.barcode=ingredients.barcode GROUP BY ingredients.iname;

-- [29]
select * from delivery_services LEFT JOIN drones ON drones.id=delivery_services.id LEFT JOIN payload ON drones.id=payload.id LEFT JOIN ingredients ON payload.barcode=ingredients.barcode;
SELECT * FROM drones;
SELECT * FROM payload;
SELECT * FROM ingredients;

SELECT * FROM payload JOIN ingredients ON payload.barcode=ingredients.barcode GROUP BY payload.id, ingredients.iname ORDER BY payload.id;

-- revenue
-- 

-- as ingredients_carried
-- select COUNT(DISTINCT iname) as ingredients_carried from delivery_services LEFT JOIN drones ON drones.id=delivery_services.id LEFT JOIN payload ON drones.id=payload.id LEFT JOIN ingredients ON payload.barcode=ingredients.barcode GROUP BY delivery_services.id;

-- as cost_carried
-- sum(price * quantity) as cost_carried

-- as weight_carried
-- sum(weight * quantity) as weight_carried

