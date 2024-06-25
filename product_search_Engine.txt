CREATE OR REPLACE PROCEDURE user_selected_product(
    product_cat VARCHAR2,
    return_status OUT NUMBER
) IS
    product_count NUMBER := 0;
    NoProduct_exception EXCEPTION;
BEGIN
    FOR i IN (SELECT ps.name AS product_name, ps.price AS product_price 
              FROM products_shopping ps 
              JOIN product_categories_shopping pc ON ps.category_id = pc.category_id 
              WHERE pc.category_name = product_cat)  
    LOOP
        DBMS_OUTPUT.PUT_LINE(i.product_name || ' $' || i.product_price);
        product_count := product_count + 1;
    END LOOP;

    return_status := product_count;

    IF product_count = 0 THEN
        RAISE NoProduct_exception;
    END IF;

EXCEPTION
    WHEN NoProduct_exception THEN
        DBMS_OUTPUT.PUT_LINE('SORRY 😢 !! Category not found 🛒');
END;

DECLARE
    TYPE match_product_record IS RECORD(
        match_product VARCHAR2(50),
        match_status NUMBER
    );

    TYPE match_log IS TABLE OF match_product_record;
    predicted_match match_log := match_log();
    match_count NUMBER := 0;
    return_status NUMBER;
    search_item VARCHAR2(20) := :Search_item;
    refined_search product_categories_shopping.category_name%TYPE;

BEGIN
    -- Clear the prediction_match_log table
    DELETE FROM prediction_match_log;

    -- Call user_selected_product procedure
    user_selected_product(search_item, return_status);

    IF return_status = 0 THEN
        FOR each_category IN (SELECT category_name FROM product_categories_shopping) LOOP
            match_count := 0;

            FOR j IN 1..LENGTH(each_category.category_name) LOOP
                FOR traverse IN 1..LENGTH(search_item) LOOP
                    IF SUBSTR(search_item, traverse, 1) = LOWER(SUBSTR(each_category.category_name, traverse, 1)) THEN
                        match_count := match_count + 1;
                    END IF;
                END LOOP;
            END LOOP;

            -- Add the matching category to the predicted_match collection
            predicted_match.EXTEND;
            predicted_match(predicted_match.count) := match_product_record(
                match_product => each_category.category_name,
                match_status => match_count
            );
        END LOOP;

        -- Insert the collected records into the prediction_match_log table
        FOR i IN 1..predicted_match.COUNT LOOP
            INSERT INTO prediction_match_log
            VALUES (predicted_match(i).match_product, predicted_match(i).match_status);
        END LOOP;

        -- Get the refined search result based on the highest match count
        SELECT product_name
        INTO refined_search
        FROM prediction_match_log
        ORDER BY total_match DESC
        FETCH FIRST 1 ROW ONLY;

        DBMS_OUTPUT.PUT_LINE('Are you looking for ' || refined_search || '? Here are the similar results:');

        -- Call user_selected_product procedure with the refined search item
        user_selected_product(refined_search, return_status);
    END IF;
END;
