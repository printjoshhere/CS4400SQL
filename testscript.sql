use restaurant_supply_express;

-- [24] display_owner_view()
SELECT restaurant_owners.username, first_name, last_name, address, count(long_name) as num_restaurants, count(distinct location) as num_places,
COALESCE(max(rating),0) as highs, COALESCE(min(rating),0) as lows, COALESCE(sum(spent),0) as debt
FROM restaurant_owners
LEFT JOIN users ON (restaurant_owners.username = users.username)
LEFT JOIN restaurants ON (restaurant_owners.username= restaurants.funded_by)
GROUP BY username;

-- [25] display_employee_view()
SELECT employees.username, employees.taxID, employees.salary, employees.hired, employees.experience as employee_experience, 
coalesce(pilots.licenseID, 'n/a') as licenseID, coalesce(pilots.experience, 'n/a') as piloting_experience, 
CASE WHEN delivery_services.id IS NOT NULL THEN 'yes' ELSE 'no' END AS manager_status FROM employees 
LEFT JOIN pilots ON pilots.username=employees.username 
LEFT JOIN work_for ON work_for.username=employees.username 
LEFT JOIN delivery_services ON delivery_services.manager=work_for.username;

-- [26] display_pilot_view()
-- Note, we have to account for all drones (might not be flown directly, but in a swarm)
-- TODO: num_drones

SELECT * FROM pilots;
SELECT * FROM drones;

SELECT pilots.username, pilots.licenseID, pilots.experience, COUNT(flown_by) as num_drones, COUNT(distinct hover) as num_locations FROM pilots
LEFT JOIN drones ON drones.flown_by=pilots.username GROUP BY pilots.username;

SELECT pilots.username, pilots.licenseID, pilots.experience, COUNT(flown_by) as num_drones, COUNT(distinct hover) as num_locations FROM pilots
LEFT JOIN drones ON drones.flown_by=pilots.username GROUP BY pilots.username;

-- [27] display_location_view()
-- locations.label, locations.x_coord, locations.y_coord, COUNT(restaurants.location) as num_restaurants, COUNT(delivery_services.home_base) as delivery_services
SELECT locations.label, locations.x_coord, locations.y_coord, COUNT(restaurants.location) as num_restaurants, COUNT(delivery_services.home_base) as delivery_services FROM locations
LEFT JOIN restaurants ON restaurants.location=locations.label
LEFT JOIN delivery_services ON delivery_services.home_base=locations.label GROUP BY locations.label; 
-- GROUP BY locations.label
-- num_drones

-- SELECT * FROM locations
-- LEFT JOIN restaurants ON restaurants.location=locations.label
-- LEFT JOIN delivery_services ON delivery_services.home_base=locations.label
-- LEFT JOIN drones ON drones.hover=locations.label GROUP BY drones.hover; 

SELECT locations.label, locations.x_coord, locations.y_coord, COUNT(drones.hover) as num_drones FROM locations 
LEFT JOIN drones ON drones.hover=locations.label
GROUP BY locations.label;

SELECT locations.label, COUNT(restaurants.location) as num_restaurants, COUNT(delivery_services.home_base) as delivery_services FROM locations 
LEFT JOIN restaurants ON restaurants.location=locations.label
LEFT JOIN delivery_services ON delivery_services.home_base=locations.label
GROUP BY locations.label;

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

-- as ingredients_carried
-- select COUNT(DISTINCT iname) as ingredients_carried from delivery_services LEFT JOIN drones ON drones.id=delivery_services.id LEFT JOIN payload ON drones.id=payload.id LEFT JOIN ingredients ON payload.barcode=ingredients.barcode GROUP BY delivery_services.id;

-- as cost_carried
-- sum(price * quantity) as cost_carried

-- as weight_carried
-- sum(weight * quantity) as weight_carried

