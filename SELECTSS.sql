
-- Видалення книги
DELETE FROM books WHERE book_id = 1;

-- Редагування книги
UPDATE books
SET price = 10.99, language = 'English'
WHERE book_id = 7;

-- Додавання нової книги
INSERT INTO books (title, author_id, isbn, price, publication_year, publisher, description, 
cover_image, file_path, language, page_count)
VALUES ('The Hobbit', 1, '9780547928227', 12.50, 1937, 'Houghton Mifflin', 'A fantasy novel about Bilbo Baggins', 
'hobbit_cover.jpg', '/books/hobbit.pdf', 'English', 310);

-- Додавання нових жанрів до конкретної книги
INSERT INTO book_genres (book_id, genre_id)
VALUES (1, 5), (1, 11)
ON DUPLICATE KEY UPDATE updated_at = CURRENT_TIMESTAMP;

-- Замовлення користувачів за датами
SELECT 
    o.order_id,
    o.order_date,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Популярність книг за кількістю замовлень
SELECT 
    b.book_id,
    b.title,
    COUNT(od.order_id) AS order_count
FROM books b
LEFT JOIN order_details od ON b.book_id = od.book_id
GROUP BY b.book_id, b.title
ORDER BY order_count DESC;

-- Середня оцінка за книгу
SELECT b.title, AVG(r.rating) AS avg_rating
FROM books b
LEFT JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title
HAVING AVG(r.rating) IS NOT NULL
ORDER BY avg_rating DESC;

-- 10 найдорожчих книг
SELECT book_id, title, price
FROM books
WHERE price>0
ORDER BY price DESC
LIMIT 10;

-- Збільшення ціни на усі платні книги на 10%
UPDATE books
SET price = price * 1.10
WHERE price > 0;

-- Пошук книги за назвою або за ім'ям чи прізвищем автора
SELECT b.*
FROM books b
JOIN authors a ON b.author_id = a.author_id
WHERE b.title LIKE '%Murder on the Orient Express%' 
   OR a.first_name LIKE '%Agatha%'
   OR a.last_name LIKE '%Christie%';

-- Перегляд книг за конкретними жанрами від дешевшої до дорожчої
SELECT b.book_id, b.title, b.price, b.publication_year, b.language, b.page_count, g.genre_name
FROM books b
JOIN book_genres bg ON b.book_id = bg.book_id
JOIN genres g ON bg.genre_id = g.genre_id
WHERE g.genre_name = 'Fantasy'
ORDER BY b.price;

-- Фільтрація в ціновому діапазоні при конкретному жанрі та заданому рейтингу з ціною по спаданню
SELECT
    b.book_id,
    b.title,
    b.price,
    AVG(r.rating) AS average_rating,
    COUNT(r.rating) AS review_count,
    g.genre_name
FROM books b
LEFT JOIN reviews r ON b.book_id = r.book_id
JOIN book_genres bg ON b.book_id = bg.book_id
JOIN genres g ON bg.genre_id = g.genre_id
WHERE b.price BETWEEN 5.00 AND 15.00
  AND g.genre_name = 'Fantasy'
GROUP BY b.book_id, b.title, b.price, g.genre_name
HAVING AVG(r.rating) >= 4.0
ORDER BY b.price DESC;
