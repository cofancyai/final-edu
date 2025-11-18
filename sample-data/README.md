# Sample Data Directory

This directory contains sample data files to populate your database for testing and development.

## Files

### 1. `exambot_comprehensive_sample_data.sql`
**Purpose:** Comprehensive sample questions for ExamBot across multiple competitive exams

**Contents:**
- **8 Exam Categories:** UPSC, SSC, Banking, Railway, GATE, CAT, NEET, JEE
- **25+ Topics:** History, Geography, Polity, Economics, Science, Quantitative Aptitude, Reasoning, English
- **50+ Subtopics:** Detailed breakdown of each topic
- **30 Sample Questions:** Realistic questions with:
  - Detailed explanations
  - Difficulty levels (Easy, Medium, Hard)
  - Year-wise organization (2023-2024)
  - Subject classification
  - Tags for filtering
  - Time estimates

**Question Distribution:**
- UPSC History: 6 questions
- UPSC Geography: 3 questions
- UPSC Polity: 3 questions
- SSC Quantitative Aptitude: 5 questions
- Banking Awareness: 3 questions
- SSC Reasoning: 3 questions
- SSC English: 3 questions
- Current Affairs: 2 questions
- Science: 2 questions

### 2. `seed_exambot_data.sql`
**Purpose:** Basic seed data for ExamBot (legacy file)

### 3. `seed_aptitude_data.sql`
**Purpose:** Sample data for the Aptitude module

## How to Use

### Prerequisites

1. **Database schema must be created first:**
   ```bash
   # Navigate to table-schema directory
   cd ../table-schema

   # Run the CORRECT schema file in Supabase SQL Editor or psql
   psql -h your-host -U postgres -d your-db -f exambot_correct_schema.sql
   ```

2. **Verify schema is ready:**
   ```sql
   SELECT table_name FROM information_schema.tables
   WHERE table_schema = 'public'
   ORDER BY table_name;
   ```

### Loading Sample Data

#### Option 1: Using Supabase Dashboard (Recommended for beginners)

1. Open your Supabase project
2. Go to **SQL Editor**
3. Copy the contents of `exambot_comprehensive_sample_data.sql`
4. Paste into the editor
5. Click **Run**
6. Verify data is loaded:
   ```sql
   SELECT exam, COUNT(*) as question_count
   FROM questions
   GROUP BY exam;
   ```

#### Option 2: Using psql (Command line)

```bash
# Load comprehensive sample data
psql -h your-host -U postgres -d your-db -f exambot_comprehensive_sample_data.sql

# Verify
psql -h your-host -U postgres -d your-db -c "SELECT COUNT(*) FROM questions;"
```

#### Option 3: Using Supabase CLI

```bash
# Login to Supabase
supabase login

# Link your project
supabase link --project-ref your-project-ref

# Run the SQL file
supabase db push --file exambot_comprehensive_sample_data.sql
```

### Verifying Data Import

After loading data, run these verification queries:

```sql
-- Check exam categories
SELECT * FROM exam_categories ORDER BY category_name;

-- Check topics
SELECT * FROM topics ORDER BY topic_name;

-- Check questions by exam
SELECT exam, COUNT(*) as total_questions
FROM questions
GROUP BY exam
ORDER BY total_questions DESC;

-- Check questions by difficulty
SELECT difficulty, COUNT(*) as count
FROM questions
GROUP BY difficulty;

-- Check year-wise distribution
SELECT year, COUNT(*) as count
FROM questions
WHERE year IS NOT NULL
GROUP BY year
ORDER BY year DESC;

-- Check subjects
SELECT DISTINCT subject
FROM questions
ORDER BY subject;
```

## Sample Data Structure

### Question Format

Each question includes:

```sql
{
  id: 'Q-UPSC-HIST-2024-001',
  exam: 'UPSC Civil Services',
  subject: 'History',
  topic_id: 'topic-hist-001',
  subtopic_id: 'subtopic-hist-001-01',
  year: 2024,
  question_number: 1,
  question: 'Question text here...',
  options: ['Option A', 'Option B', 'Option C', 'Option D'],
  answer: 'C',
  detailed_explanation: 'Detailed explanation...',
  difficulty: 'Medium',
  tags: ['IVC', 'Geography', 'Trade'],
  question_type: 'multiple_choice',
  time_estimate: 60
}
```

### ID Naming Convention

Questions use a structured ID format:
- `Q-{EXAM}-{SUBJECT}-{YEAR}-{NUMBER}`
- Example: `Q-UPSC-HIST-2024-001`
  - Q = Question
  - UPSC = Exam
  - HIST = Subject abbreviation
  - 2024 = Year
  - 001 = Question number

### Topics and Subtopics

Hierarchical organization:
- `topic-hist-001` → Ancient Indian History
  - `subtopic-hist-001-01` → Indus Valley Civilization
  - `subtopic-hist-001-02` → Vedic Period
  - `subtopic-hist-001-03` → Mauryan Empire
  - `subtopic-hist-001-04` → Gupta Period

## Extending Sample Data

### Adding New Questions

1. **Follow the existing format:**
   ```sql
   INSERT INTO questions (
     id, exam, subject, topic_id, subtopic_id,
     year, question_number, question, options,
     answer, detailed_explanation, difficulty,
     tags, question_type, time_estimate, created_at
   ) VALUES (
     'Q-EXAM-SUBJ-YEAR-NUM',
     'Exam Name',
     'Subject',
     'topic-id',
     'subtopic-id',
     2024,
     1,
     'Your question text',
     ARRAY['Option A', 'Option B', 'Option C', 'Option D'],
     'A',
     'Explanation',
     'Medium',
     ARRAY['tag1', 'tag2'],
     'multiple_choice',
     60,
     NOW()
   );
   ```

2. **Maintain consistency:**
   - Use same exam names as in `exam_categories`
   - Reference existing `topic_id` and `subtopic_id`
   - Follow difficulty levels: Easy, Medium, Hard
   - Keep time estimates realistic (45-120 seconds)

3. **Add explanations:**
   - Every question should have a detailed explanation
   - Explain why the answer is correct
   - Mention why other options are incorrect (if relevant)

### Adding New Exams

1. **Add to exam_categories:**
   ```sql
   INSERT INTO exam_categories (id, category_name, description, icon, is_active)
   VALUES ('exam-new-001', 'New Exam', 'Description', '📝', true);
   ```

2. **Add related topics and subtopics**

3. **Add questions for the new exam**

### Adding New Topics

1. **Add to topics table:**
   ```sql
   INSERT INTO topics (id, topic_name, description)
   VALUES ('topic-new-001', 'New Topic', 'Description');
   ```

2. **Add subtopics if needed:**
   ```sql
   INSERT INTO subtopics (id, topic_id, subtopic_name)
   VALUES ('subtopic-new-001-01', 'topic-new-001', 'Subtopic 1');
   ```

3. **Add questions for the new topic**

## Data Quality Guidelines

### Question Writing Standards

1. **Clear and concise** - Questions should be easy to understand
2. **No ambiguity** - Only one correct answer
3. **Appropriate difficulty** - Match the difficulty tag
4. **Realistic options** - All options should be plausible
5. **Quality explanations** - Help users learn, not just test

### Option Guidelines

1. **Same length** - Options should be similar in length
2. **No "all of the above"** - Avoid unless necessary
3. **No "none of the above"** - Unless it adds value
4. **Randomize order** - Don't always put correct answer in same position

### Difficulty Levels

- **Easy:** 80%+ users should answer correctly, basic recall, 45-60 seconds
- **Medium:** 50-70% accuracy, requires understanding, 60-90 seconds
- **Hard:** <50% accuracy, requires analysis/application, 90-120 seconds

## Maintenance

### Regular Updates

1. **Add current year questions** - Update yearly
2. **Review accuracy** - Fix errors reported by users
3. **Update explanations** - Improve based on feedback
4. **Archive outdated content** - Mark old questions as inactive

### Quality Checks

Run these queries periodically:

```sql
-- Questions without explanations
SELECT id, question FROM questions
WHERE detailed_explanation IS NULL OR detailed_explanation = '';

-- Questions with invalid options
SELECT id, question FROM questions
WHERE array_length(options, 1) != 4;

-- Questions without tags
SELECT id, question FROM questions
WHERE tags IS NULL OR array_length(tags, 1) = 0;

-- Orphaned questions (no valid topic)
SELECT q.id, q.question
FROM questions q
LEFT JOIN topics t ON q.topic_id = t.id
WHERE t.id IS NULL;
```

## Performance Tips

### Batch Inserts

For large datasets, use batch inserts:

```sql
BEGIN;

INSERT INTO questions (...) VALUES (...), (...), (...);
-- Insert multiple rows at once

COMMIT;
```

### Disable Triggers Temporarily (if needed)

```sql
-- Disable triggers for bulk insert
ALTER TABLE questions DISABLE TRIGGER ALL;

-- Your bulk insert here
INSERT INTO questions ...;

-- Re-enable triggers
ALTER TABLE questions ENABLE TRIGGER ALL;
```

### Use COPY for Large Files

For very large datasets (10,000+ rows):

```bash
# Create CSV file first
# Then use COPY command
\copy questions FROM 'questions.csv' WITH (FORMAT csv, HEADER true);
```

## Troubleshooting

### Common Errors

**Error: Duplicate key value violates unique constraint**
```sql
-- Check for duplicate IDs
SELECT id, COUNT(*) FROM questions GROUP BY id HAVING COUNT(*) > 1;
```

**Error: Foreign key violation**
```sql
-- Verify topic exists before adding question
SELECT * FROM topics WHERE id = 'topic-hist-001';
```

**Error: Invalid array format**
```sql
-- Correct format for options
ARRAY['Option A', 'Option B', 'Option C', 'Option D']

-- Not this:
'["Option A", "Option B"]'  -- Wrong! This is a string, not an array
```

## Best Practices

1. ✅ **Always test on development database first**
2. ✅ **Backup before major data imports**
3. ✅ **Use transactions for related inserts**
4. ✅ **Validate data before inserting**
5. ✅ **Keep sample data updated with current year**
6. ✅ **Document any custom data structures**

## Next Steps

After loading sample data:

1. **Test the ExamBot UI** - Verify filters work correctly
2. **Check all exam categories appear** - In the exam selection dropdown
3. **Test practice mode** - Can you start a practice session?
4. **Verify explanations display** - Are explanations readable?
5. **Test filtering** - Do subject/topic/year filters work?

## Contributing

To contribute sample data:

1. Follow the existing format
2. Ensure questions are accurate and verified
3. Add proper explanations
4. Include appropriate tags
5. Test before submitting
6. Document any new categories/topics

## License

Sample data is provided for educational and testing purposes. Ensure compliance with copyright when using real exam questions.

---

**Questions or Issues?** Please refer to the main project documentation or create an issue in the repository.
