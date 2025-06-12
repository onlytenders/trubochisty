INSERT INTO culverts (
    id, address, coordinates, road, serial_number, pipe_type, material,
    diameter, length, head_type, foundation_type, work_type, construction_year,
    strength_rating, safety_rating, maintainability_rating, general_condition_rating
) VALUES (
    'test-id-1',
    'Test Address 1',
    '55.7558,37.6173',
    'Test Road 1',
    'TEST-001',
    'Round',
    'Concrete',
    1.5,
    12.0,
    'Standard',
    'Concrete',
    'New Construction',
    2020,
    4.5,
    4.0,
    4.2,
    4.3
);

INSERT INTO culverts (
    id, address, coordinates, road, serial_number, pipe_type, material,
    diameter, length, head_type, foundation_type, work_type, construction_year,
    strength_rating, safety_rating, maintainability_rating, general_condition_rating
) VALUES (
    'test-id-2',
    'Test Address 2',
    '55.7697,37.6398',
    'Test Road 2',
    'TEST-002',
    'Rectangular',
    'Steel',
    2.0,
    8.5,
    'Custom',
    'Steel',
    'Rehabilitation',
    2019,
    3.8,
    3.5,
    3.7,
    3.6
); 