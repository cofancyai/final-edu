-- ExamBot Comprehensive Sample Data
-- This file contains realistic sample questions for various competitive exams
-- Use this to populate your database for testing and demonstration

-- ============================================
-- EXAM CATEGORIES
-- ============================================

INSERT INTO exam_categories (id, category_name, description, icon, is_active, created_at) VALUES
('exam-upsc-001', 'UPSC Civil Services', 'Union Public Service Commission - Civil Services Examination', '🏛️', true, NOW()),
('exam-ssc-002', 'SSC CGL', 'Staff Selection Commission - Combined Graduate Level', '📚', true, NOW()),
('exam-bank-003', 'Banking (IBPS)', 'Institute of Banking Personnel Selection', '🏦', true, NOW()),
('exam-railway-004', 'Railway Recruitment', 'Railway Recruitment Board Examinations', '🚂', true, NOW()),
('exam-gate-005', 'GATE', 'Graduate Aptitude Test in Engineering', '⚙️', true, NOW()),
('exam-cat-006', 'CAT', 'Common Admission Test', '💼', true, NOW()),
('exam-neet-007', 'NEET', 'National Eligibility cum Entrance Test', '🏥', true, NOW()),
('exam-jee-008', 'JEE Main', 'Joint Entrance Examination', '🔬', true, NOW());

-- ============================================
-- TOPICS
-- ============================================

INSERT INTO topics (id, topic_name, description, created_at) VALUES
-- History Topics
('topic-hist-001', 'Ancient Indian History', 'Indus Valley Civilization to Gupta Period', NOW()),
('topic-hist-002', 'Medieval Indian History', 'Delhi Sultanate to Mughal Empire', NOW()),
('topic-hist-003', 'Modern Indian History', 'British India and Freedom Movement', NOW()),
('topic-hist-004', 'World History', 'Major World Events and Civilizations', NOW()),

-- Geography Topics
('topic-geo-001', 'Physical Geography', 'Landforms, Climate, and Natural Resources', NOW()),
('topic-geo-002', 'Indian Geography', 'Indian Physical and Economic Geography', NOW()),
('topic-geo-003', 'World Geography', 'Continents, Countries, and Physical Features', NOW()),

-- Polity Topics
('topic-pol-001', 'Indian Constitution', 'Constitutional Framework and Amendments', NOW()),
('topic-pol-002', 'Governance', 'Government Structure and Administration', NOW()),
('topic-pol-003', 'International Relations', 'Foreign Policy and International Organizations', NOW()),

-- Economics Topics
('topic-econ-001', 'Indian Economy', 'Economic Development and Planning', NOW()),
('topic-econ-002', 'Banking and Finance', 'Monetary Policy and Financial Institutions', NOW()),
('topic-econ-003', 'World Economy', 'Global Economic Trends', NOW()),

-- Science Topics
('topic-sci-001', 'Physics', 'Classical and Modern Physics', NOW()),
('topic-sci-002', 'Chemistry', 'Organic, Inorganic, and Physical Chemistry', NOW()),
('topic-sci-003', 'Biology', 'Botany, Zoology, and Human Biology', NOW()),

-- Quantitative Aptitude
('topic-quant-001', 'Arithmetic', 'Number Systems, Percentages, Profit-Loss', NOW()),
('topic-quant-002', 'Algebra', 'Equations, Polynomials, and Functions', NOW()),
('topic-quant-003', 'Geometry', 'Shapes, Angles, and Mensuration', NOW()),

-- Reasoning
('topic-reason-001', 'Logical Reasoning', 'Syllogisms, Coding-Decoding, Series', NOW()),
('topic-reason-002', 'Analytical Reasoning', 'Puzzles and Data Sufficiency', NOW()),

-- English
('topic-eng-001', 'Grammar', 'Parts of Speech, Tenses, Voice', NOW()),
('topic-eng-002', 'Vocabulary', 'Synonyms, Antonyms, Idioms', NOW()),
('topic-eng-003', 'Comprehension', 'Reading Comprehension and Para Jumbles', NOW());

-- ============================================
-- SUBTOPICS
-- ============================================

INSERT INTO subtopics (id, topic_id, subtopic_name, created_at) VALUES
-- Ancient History Subtopics
('subtopic-hist-001-01', 'topic-hist-001', 'Indus Valley Civilization', NOW()),
('subtopic-hist-001-02', 'topic-hist-001', 'Vedic Period', NOW()),
('subtopic-hist-001-03', 'topic-hist-001', 'Mauryan Empire', NOW()),
('subtopic-hist-001-04', 'topic-hist-001', 'Gupta Period', NOW()),

-- Modern History Subtopics
('subtopic-hist-003-01', 'topic-hist-003', 'Revolt of 1857', NOW()),
('subtopic-hist-003-02', 'topic-hist-003', 'Indian National Congress', NOW()),
('subtopic-hist-003-03', 'topic-hist-003', 'Freedom Movement', NOW()),
('subtopic-hist-003-04', 'topic-hist-003', 'Post-Independence India', NOW()),

-- Indian Geography Subtopics
('subtopic-geo-002-01', 'topic-geo-002', 'Indian Rivers', NOW()),
('subtopic-geo-002-02', 'topic-geo-002', 'Mountain Ranges', NOW()),
('subtopic-geo-002-03', 'topic-geo-002', 'Climate of India', NOW()),

-- Constitution Subtopics
('subtopic-pol-001-01', 'topic-pol-001', 'Fundamental Rights', NOW()),
('subtopic-pol-001-02', 'topic-pol-001', 'Directive Principles', NOW()),
('subtopic-pol-001-03', 'topic-pol-001', 'Union Government', NOW()),
('subtopic-pol-001-04', 'topic-pol-001', 'State Government', NOW()),

-- Economy Subtopics
('subtopic-econ-001-01', 'topic-econ-001', 'Five Year Plans', NOW()),
('subtopic-econ-001-02', 'topic-econ-001', 'Inflation and Deflation', NOW()),
('subtopic-econ-001-03', 'topic-econ-001', 'GDP and National Income', NOW()),

-- Banking Subtopics
('subtopic-econ-002-01', 'topic-econ-002', 'Reserve Bank of India', NOW()),
('subtopic-econ-002-02', 'topic-econ-002', 'Commercial Banking', NOW()),
('subtopic-econ-002-03', 'topic-econ-002', 'Digital Banking', NOW()),

-- Quantitative Subtopics
('subtopic-quant-001-01', 'topic-quant-001', 'Percentages', NOW()),
('subtopic-quant-001-02', 'topic-quant-001', 'Profit and Loss', NOW()),
('subtopic-quant-001-03', 'topic-quant-001', 'Simple and Compound Interest', NOW()),
('subtopic-quant-001-04', 'topic-quant-001', 'Time and Work', NOW()),
('subtopic-quant-001-05', 'topic-quant-001', 'Time Speed Distance', NOW());

-- ============================================
-- QUESTIONS - UPSC HISTORY
-- ============================================

INSERT INTO questions (id, exam, subject, topic_id, subtopic_id, year, question_number, question, options, answer, detailed_explanation, difficulty, tags, question_type, time_estimate, created_at) VALUES

-- Ancient History Questions
('Q-UPSC-HIST-2024-001', 'UPSC Civil Services', 'History', 'topic-hist-001', 'subtopic-hist-001-01', 2024, 1,
'Which of the following sites of Indus Valley Civilization is located in present-day Afghanistan?',
ARRAY['Harappa', 'Mohenjo-daro', 'Shortugai', 'Lothal'],
'C',
'Shortugai is the only Indus Valley Civilization site located in present-day Afghanistan. It was a trading outpost in the Badakhshan province. Harappa and Mohenjo-daro are in Pakistan, while Lothal is in Gujarat, India.',
'Medium',
ARRAY['IVC', 'Geography', 'Trade'],
'multiple_choice',
60,
NOW()),

('Q-UPSC-HIST-2024-002', 'UPSC Civil Services', 'History', 'topic-hist-001', 'subtopic-hist-001-03', 2024, 2,
'The Arthashastra written by Kautilya is primarily related to which empire?',
ARRAY['Gupta Empire', 'Mauryan Empire', 'Kushan Empire', 'Chola Empire'],
'B',
'The Arthashastra was written by Kautilya (also known as Chanakya), who was the chief advisor to Chandragupta Maurya, the founder of the Mauryan Empire. It deals with statecraft, economic policy, and military strategy.',
'Easy',
ARRAY['Mauryan', 'Literature', 'Kautilya'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-HIST-2023-003', 'UPSC Civil Services', 'History', 'topic-hist-001', 'subtopic-hist-001-04', 2023, 3,
'The concept of "Zero" and the decimal system was developed during which period?',
ARRAY['Vedic Period', 'Mauryan Period', 'Gupta Period', 'Mughal Period'],
'C',
'The concept of zero and the decimal system was developed during the Gupta Period (4th-6th century CE). Mathematician Aryabhata made significant contributions to astronomy and mathematics during this golden age of Indian science.',
'Easy',
ARRAY['Science', 'Mathematics', 'Gupta'],
'multiple_choice',
45,
NOW()),

-- Modern History Questions
('Q-UPSC-HIST-2024-004', 'UPSC Civil Services', 'History', 'topic-hist-003', 'subtopic-hist-003-01', 2024, 4,
'The Revolt of 1857 was first started from which place?',
ARRAY['Delhi', 'Meerut', 'Lucknow', 'Kanpur'],
'B',
'The Revolt of 1857, also known as the First War of Independence, started from Meerut on May 10, 1857, when sepoys refused to use the new Enfield rifle cartridges which were allegedly greased with cow and pig fat.',
'Easy',
ARRAY['1857 Revolt', 'British India'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-HIST-2023-005', 'UPSC Civil Services', 'History', 'topic-hist-003', 'subtopic-hist-003-02', 2023, 5,
'Who founded the Indian National Congress in 1885?',
ARRAY['Mahatma Gandhi', 'A.O. Hume', 'Jawaharlal Nehru', 'Bal Gangadhar Tilak'],
'B',
'The Indian National Congress was founded by Allan Octavian Hume, a retired British civil servant, in 1885. The first session was held in Bombay with W.C. Bonnerjee as the first president.',
'Easy',
ARRAY['INC', 'Freedom Movement'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-HIST-2024-006', 'UPSC Civil Services', 'History', 'topic-hist-003', 'subtopic-hist-003-03', 2024, 6,
'The Quit India Movement was launched in which year?',
ARRAY['1940', '1942', '1944', '1946'],
'B',
'The Quit India Movement was launched by Mahatma Gandhi on August 8, 1942, at the Bombay session of the All India Congress Committee. The slogan "Do or Die" was given during this movement.',
'Easy',
ARRAY['Freedom Movement', 'Gandhi', 'Civil Disobedience'],
'multiple_choice',
45,
NOW()),

-- ============================================
-- QUESTIONS - UPSC GEOGRAPHY
-- ============================================

('Q-UPSC-GEO-2024-007', 'UPSC Civil Services', 'Geography', 'topic-geo-002', 'subtopic-geo-002-01', 2024, 7,
'Which of the following rivers does NOT originate in India?',
ARRAY['Ganga', 'Brahmaputra', 'Godavari', 'Kaveri'],
'B',
'The Brahmaputra originates in the Angsi Glacier in Tibet (China) near Lake Mansarovar. It enters India through Arunachal Pradesh. Ganga, Godavari, and Kaveri all originate within Indian territory.',
'Medium',
ARRAY['Rivers', 'Physical Geography'],
'multiple_choice',
60,
NOW()),

('Q-UPSC-GEO-2023-008', 'UPSC Civil Services', 'Geography', 'topic-geo-002', 'subtopic-geo-002-02', 2023, 8,
'The Western Ghats are also known as:',
ARRAY['Sahyadri', 'Aravalli', 'Vindhya', 'Satpura'],
'A',
'The Western Ghats are also known as Sahyadri. They run parallel to the western coast of India and are a UNESCO World Heritage Site known for their biodiversity.',
'Easy',
ARRAY['Mountains', 'Western Ghats', 'UNESCO'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-GEO-2024-009', 'UPSC Civil Services', 'Geography', 'topic-geo-002', 'subtopic-geo-002-03', 2024, 9,
'Which type of climate is found in the Malabar Coast?',
ARRAY['Tropical Wet', 'Tropical Dry', 'Subtropical Humid', 'Mediterranean'],
'A',
'The Malabar Coast experiences a Tropical Wet climate characterized by heavy monsoon rainfall. The Western Ghats cause orographic rainfall in this region, making it one of the wettest regions in India.',
'Medium',
ARRAY['Climate', 'Monsoon', 'Coastal Geography'],
'multiple_choice',
60,
NOW()),

-- ============================================
-- QUESTIONS - UPSC POLITY
-- ============================================

('Q-UPSC-POL-2024-010', 'UPSC Civil Services', 'Polity', 'topic-pol-001', 'subtopic-pol-001-01', 2024, 10,
'Which Article of the Indian Constitution deals with the Right to Equality?',
ARRAY['Article 12', 'Article 14', 'Article 19', 'Article 21'],
'B',
'Article 14 of the Indian Constitution guarantees the Right to Equality before law and equal protection of laws. Articles 14-18 collectively deal with the Right to Equality.',
'Easy',
ARRAY['Fundamental Rights', 'Constitution', 'Rights'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-POL-2023-011', 'UPSC Civil Services', 'Polity', 'topic-pol-001', 'subtopic-pol-001-02', 2023, 11,
'Which of the following is NOT a Directive Principle of State Policy?',
ARRAY['Right to work', 'Right to education', 'Equal pay for equal work', 'Freedom of speech'],
'D',
'Freedom of speech is a Fundamental Right under Article 19, not a Directive Principle. Directive Principles are given in Part IV (Articles 36-51) and include right to work, equal pay for equal work, and originally right to education (now a Fundamental Right).',
'Medium',
ARRAY['DPSP', 'Fundamental Rights', 'Constitution'],
'multiple_choice',
60,
NOW()),

('Q-UPSC-POL-2024-012', 'UPSC Civil Services', 'Polity', 'topic-pol-001', 'subtopic-pol-001-03', 2024, 12,
'The President of India is elected by:',
ARRAY['Direct election by people', 'Electoral College', 'Parliament', 'Supreme Court'],
'B',
'The President of India is elected by an Electoral College consisting of elected members of both Houses of Parliament and elected members of the Legislative Assemblies of States and Union Territories.',
'Easy',
ARRAY['President', 'Election', 'Constitutional Bodies'],
'multiple_choice',
45,
NOW()),

-- ============================================
-- QUESTIONS - SSC QUANTITATIVE APTITUDE
-- ============================================

('Q-SSC-QUANT-2024-013', 'SSC CGL', 'Quantitative Aptitude', 'topic-quant-001', 'subtopic-quant-001-01', 2024, 13,
'If 40% of a number is 80, what is 60% of that number?',
ARRAY['100', '120', '140', '160'],
'B',
'If 40% of x = 80, then x = 80 × (100/40) = 200. Therefore, 60% of 200 = (60/100) × 200 = 120.',
'Easy',
ARRAY['Percentage', 'Basic Math'],
'multiple_choice',
90,
NOW()),

('Q-SSC-QUANT-2024-014', 'SSC CGL', 'Quantitative Aptitude', 'topic-quant-001', 'subtopic-quant-001-02', 2024, 14,
'A shopkeeper sells an article at 20% profit. If the cost price increases by 10% and selling price remains same, what is the new profit percentage?',
ARRAY['8%', '9%', '10%', '12%'],
'B',
'Let CP = 100, SP = 120 (20% profit). New CP = 110. New Profit = 120 - 110 = 10. New Profit% = (10/110) × 100 = 9.09% ≈ 9%',
'Medium',
ARRAY['Profit Loss', 'Percentage'],
'multiple_choice',
120,
NOW()),

('Q-SSC-QUANT-2023-015', 'SSC CGL', 'Quantitative Aptitude', 'topic-quant-001', 'subtopic-quant-001-03', 2023, 15,
'What is the compound interest on Rs. 10,000 at 10% per annum for 2 years?',
ARRAY['Rs. 2,000', 'Rs. 2,100', 'Rs. 2,200', 'Rs. 2,500'],
'B',
'CI = P[(1 + r/100)^n - 1] = 10000[(1.1)^2 - 1] = 10000[1.21 - 1] = 10000 × 0.21 = Rs. 2,100',
'Medium',
ARRAY['Compound Interest', 'Banking'],
'multiple_choice',
120,
NOW()),

('Q-SSC-QUANT-2024-016', 'SSC CGL', 'Quantitative Aptitude', 'topic-quant-001', 'subtopic-quant-001-04', 2024, 16,
'A can complete a work in 10 days and B can complete the same work in 15 days. If they work together, in how many days will they complete the work?',
ARRAY['5 days', '6 days', '7 days', '8 days'],
'B',
'A''s 1 day work = 1/10, B''s 1 day work = 1/15. Combined = 1/10 + 1/15 = 5/30 = 1/6. Therefore, they will complete the work in 6 days.',
'Medium',
ARRAY['Time and Work', 'Work Efficiency'],
'multiple_choice',
120,
NOW()),

('Q-SSC-QUANT-2023-017', 'SSC CGL', 'Quantitative Aptitude', 'topic-quant-001', 'subtopic-quant-001-05', 2023, 17,
'A train travels 120 km at 60 km/hr and returns at 40 km/hr. What is the average speed for the entire journey?',
ARRAY['48 km/hr', '50 km/hr', '52 km/hr', '55 km/hr'],
'A',
'Average speed = 2xy/(x+y) = 2×60×40/(60+40) = 4800/100 = 48 km/hr',
'Medium',
ARRAY['Time Speed Distance', 'Average Speed'],
'multiple_choice',
120,
NOW()),

-- ============================================
-- QUESTIONS - BANKING
-- ============================================

('Q-BANK-ECON-2024-018', 'Banking (IBPS)', 'Banking Awareness', 'topic-econ-002', 'subtopic-econ-002-01', 2024, 18,
'What is the current Cash Reserve Ratio (CRR) as of 2024?',
ARRAY['3%', '4%', '4.5%', '5%'],
'C',
'As of 2024, the Cash Reserve Ratio (CRR) maintained by the Reserve Bank of India is 4.5%. CRR is the percentage of total deposits that banks must keep with the RBI in cash.',
'Easy',
ARRAY['RBI', 'Monetary Policy', 'CRR'],
'multiple_choice',
60,
NOW()),

('Q-BANK-ECON-2024-019', 'Banking (IBPS)', 'Banking Awareness', 'topic-econ-002', 'subtopic-econ-002-02', 2024, 19,
'Which of the following is NOT a function of commercial banks?',
ARRAY['Accepting deposits', 'Granting loans', 'Issuing currency notes', 'Providing locker facilities'],
'C',
'Issuing currency notes is the exclusive function of the Reserve Bank of India (central bank), not commercial banks. Commercial banks can accept deposits, grant loans, and provide locker facilities.',
'Easy',
ARRAY['Banking Functions', 'Commercial Banking'],
'multiple_choice',
60,
NOW()),

('Q-BANK-ECON-2023-020', 'Banking (IBPS)', 'Banking Awareness', 'topic-econ-002', 'subtopic-econ-002-03', 2023, 20,
'UPI stands for:',
ARRAY['Unified Payment Interface', 'Universal Payment Integration', 'United Payment Infrastructure', 'Unique Payment Identifier'],
'A',
'UPI stands for Unified Payment Interface. It is an instant real-time payment system developed by National Payments Corporation of India (NPCI) facilitating inter-bank peer-to-peer and person-to-merchant transactions.',
'Easy',
ARRAY['Digital Banking', 'UPI', 'Payments'],
'multiple_choice',
45,
NOW()),

-- ============================================
-- QUESTIONS - REASONING
-- ============================================

('Q-SSC-REASON-2024-021', 'SSC CGL', 'Reasoning', 'topic-reason-001', NULL, 2024, 21,
'In a certain code, COMPUTER is written as RFUVQNPC. How is MEDICINE written in that code?',
ARRAY['EOJDJEFM', 'EOJEFDJM', 'NFEDJJOF', 'MFEJDJOF'],
'D',
'The pattern is: each letter is replaced by the letter that comes after it in the alphabet (reverse order). M→M (stays), E→F, D→E, I→J, C→D, I→J, N→O, E→F. So MEDICINE = MFEJDJOF',
'Hard',
ARRAY['Coding-Decoding', 'Letter Substitution'],
'multiple_choice',
120,
NOW()),

('Q-SSC-REASON-2024-022', 'SSC CGL', 'Reasoning', 'topic-reason-001', NULL, 2024, 22,
'Find the missing number in the series: 2, 6, 12, 20, 30, ?',
ARRAY['40', '42', '44', '48'],
'B',
'The pattern is: 1×2=2, 2×3=6, 3×4=12, 4×5=20, 5×6=30, 6×7=42. Each term is the product of two consecutive numbers.',
'Medium',
ARRAY['Number Series', 'Pattern Recognition'],
'multiple_choice',
90,
NOW()),

('Q-SSC-REASON-2023-023', 'SSC CGL', 'Reasoning', 'topic-reason-002', NULL, 2023, 23,
'Five friends A, B, C, D, and E are sitting in a row. A is to the right of B and E is to the left of B but right of C. A is to the left of D. Who is sitting in the middle?',
ARRAY['A', 'B', 'C', 'D', 'E'],
'B',
'Arrangement: C - E - B - A - D. Therefore, B is sitting in the middle.',
'Medium',
ARRAY['Seating Arrangement', 'Logical Reasoning'],
'multiple_choice',
120,
NOW()),

-- ============================================
-- QUESTIONS - ENGLISH
-- ============================================

('Q-SSC-ENG-2024-024', 'SSC CGL', 'English', 'topic-eng-001', NULL, 2024, 24,
'Choose the correct option: Neither of the two boys _____ present in the class.',
ARRAY['were', 'was', 'are', 'have been'],
'B',
'The correct answer is "was" because "neither" is singular and takes a singular verb. Neither of the two boys was present in the class.',
'Easy',
ARRAY['Grammar', 'Subject-Verb Agreement'],
'multiple_choice',
60,
NOW()),

('Q-SSC-ENG-2024-025', 'SSC CGL', 'English', 'topic-eng-002', NULL, 2024, 25,
'Choose the synonym of "EPHEMERAL":',
ARRAY['Permanent', 'Transient', 'Eternal', 'Lasting'],
'B',
'Ephemeral means lasting for a very short time. Transient also means lasting for a short time, making it the correct synonym.',
'Medium',
ARRAY['Vocabulary', 'Synonyms'],
'multiple_choice',
60,
NOW()),

('Q-SSC-ENG-2023-026', 'SSC CGL', 'English', 'topic-eng-002', NULL, 2023, 26,
'Choose the antonym of "ABUNDANT":',
ARRAY['Plentiful', 'Scarce', 'Ample', 'Copious'],
'B',
'Abundant means existing in large quantities. Scarce means insufficient in quantity, making it the correct antonym.',
'Easy',
ARRAY['Vocabulary', 'Antonyms'],
'multiple_choice',
60,
NOW()),

-- ============================================
-- QUESTIONS - CURRENT AFFAIRS
-- ============================================

('Q-UPSC-CA-2024-027', 'UPSC Civil Services', 'Current Affairs', 'topic-pol-003', NULL, 2024, 27,
'G20 Summit 2023 was held in which city?',
ARRAY['Mumbai', 'Bangalore', 'New Delhi', 'Hyderabad'],
'C',
'The G20 Summit 2023 was held in New Delhi, India on September 9-10, 2023. India held the G20 presidency and the theme was "Vasudhaiva Kutumbakam" - One Earth, One Family, One Future.',
'Easy',
ARRAY['International Relations', 'G20', 'Current Affairs'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-CA-2024-028', 'UPSC Civil Services', 'Current Affairs', 'topic-pol-003', NULL, 2024, 28,
'Chandrayaan-3 mission successfully landed on the Moon in which year?',
ARRAY['2021', '2022', '2023', '2024'],
'C',
'Chandrayaan-3 successfully landed on the Moon on August 23, 2023, making India the fourth country to achieve a soft landing on the lunar surface and the first to land near the South Pole.',
'Easy',
ARRAY['Space', 'ISRO', 'Science & Technology'],
'multiple_choice',
45,
NOW()),

-- ============================================
-- QUESTIONS - SCIENCE
-- ============================================

('Q-UPSC-SCI-2024-029', 'UPSC Civil Services', 'Science & Technology', 'topic-sci-001', NULL, 2024, 29,
'What is the SI unit of electric current?',
ARRAY['Volt', 'Ampere', 'Ohm', 'Watt'],
'B',
'The SI unit of electric current is Ampere (A), named after French physicist André-Marie Ampère. It represents the flow of electric charge.',
'Easy',
ARRAY['Physics', 'Electricity', 'SI Units'],
'multiple_choice',
45,
NOW()),

('Q-UPSC-SCI-2023-030', 'UPSC Civil Services', 'Science & Technology', 'topic-sci-003', NULL, 2023, 30,
'Which vitamin is also known as Ascorbic Acid?',
ARRAY['Vitamin A', 'Vitamin B12', 'Vitamin C', 'Vitamin D'],
'C',
'Vitamin C is also known as Ascorbic Acid. It is a water-soluble vitamin essential for the growth and repair of tissues, and acts as an antioxidant.',
'Easy',
ARRAY['Biology', 'Nutrition', 'Vitamins'],
'multiple_choice',
45,
NOW());

-- ============================================
-- Add more questions for different difficulty levels
-- ============================================

-- Note: This is a sample dataset. In production, you would have thousands of questions
-- covering all topics, subtopics, and difficulty levels for each exam.

-- Update statistics (optional)
-- You can add triggers or scheduled jobs to update question counts, view counts, etc.

COMMENT ON TABLE questions IS 'Main question bank for ExamBot with support for multiple exams and filtering';
COMMENT ON COLUMN questions.options IS 'Array of answer options in order A, B, C, D';
COMMENT ON COLUMN questions.answer IS 'Correct answer letter: A, B, C, or D';
COMMENT ON COLUMN questions.difficulty IS 'Easy, Medium, or Hard';
COMMENT ON COLUMN questions.tags IS 'Additional tags for enhanced filtering';
