# Table Schema Directory

This directory contains all database schema files for the PrepNX educational platform.

## Files

### 1. `exambot_schema.sql`
**Purpose:** Complete database schema for the ExamBot question bank system

**Tables included:**
- `exams` - Exam categories (UPSC, SSC, Banking, etc.)
- `subjects` - Subject classification within exams
- `chapters` - Chapter/topic organization
- `topics` - Sub-topic organization (optional)
- `questions` - Main question bank with all metadata
- `user_question_progress` - Track user progress per question
- `test_sessions` - Track user test sessions
- `test_session_answers` - Store answers for each test session

**Features:**
- Row Level Security (RLS) policies
- Automatic timestamp updates
- Indexes for performance
- Support for multiple exam types
- Hierarchical organization (Exam → Subject → Chapter → Topic)

**Usage:**
```bash
# Run this in your Supabase SQL Editor
psql -h your-db-host -U postgres -d your-database -f exambot_schema.sql
```

### 2. `aptitude_schema.sql`
**Purpose:** Database schema for the Aptitude module

**Tables included:**
- Aptitude-specific question banks
- Practice mode tracking
- Skill assessment tables

### 3. `supabase_functions.sql`
**Purpose:** Database functions and stored procedures

**Functions included:**
- Helper functions for query optimization
- Aggregation functions
- Data validation functions

## How to Use

### Initial Setup

1. **Create a new Supabase project** or use existing one

2. **Run the schema files in order:**
   ```sql
   -- First: Create main schema
   \i exambot_schema.sql

   -- Second: Create aptitude schema (if needed)
   \i aptitude_schema.sql

   -- Third: Add functions
   \i supabase_functions.sql
   ```

3. **Verify tables are created:**
   ```sql
   SELECT table_name
   FROM information_schema.tables
   WHERE table_schema = 'public';
   ```

### Updating Schema

When modifying schema:

1. **Always backup first:**
   ```bash
   pg_dump -h your-host -U postgres -d your-db > backup_$(date +%Y%m%d).sql
   ```

2. **Test on development database first**

3. **Use migrations for production:**
   - Create new migration file
   - Test thoroughly
   - Apply with version control

### Schema Naming Conventions

- **Tables:** Lowercase with underscores (`exam_categories`, `user_question_progress`)
- **Columns:** Lowercase with underscores (`created_at`, `is_active`)
- **Indexes:** Prefix with `idx_` (`idx_questions_exam`)
- **Foreign Keys:** Use descriptive names (`fk_questions_exam_id`)

## Schema Relationships

```
exams (1) ────> (many) subjects
subjects (1) ──> (many) chapters
chapters (1) ──> (many) topics
topics (1) ────> (many) questions
questions (1) ─> (many) user_question_progress
questions (1) ─> (many) test_session_answers
```

## Important Notes

### Performance Considerations

1. **Indexes are crucial** - Already added for frequently queried columns
2. **Use connection pooling** - For production deployments
3. **Monitor slow queries** - Use Supabase dashboard analytics
4. **Partition large tables** - Consider for questions table if >10M rows

### Security

1. **RLS is enabled** - All tables have Row Level Security
2. **Policies are defined** - Users can only access their own data
3. **Admin access** - Requires service role key
4. **API keys** - Use environment variables, never commit

### Backup Strategy

1. **Daily automated backups** - Configure in Supabase settings
2. **Point-in-time recovery** - Available for Pro+ plans
3. **Export before major changes** - Use `pg_dump`

## Troubleshooting

### Common Issues

**Issue: Tables not appearing**
```sql
-- Check if tables exist
SELECT * FROM pg_tables WHERE schemaname = 'public';
```

**Issue: Permission denied**
```sql
-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres;
```

**Issue: Foreign key violations**
```sql
-- Check constraints
SELECT * FROM information_schema.table_constraints
WHERE table_schema = 'public';
```

## Version History

- **v1.0** (2024-11-18): Initial schema with ExamBot support
- **v1.1** (TBD): Add user analytics tables
- **v2.0** (TBD): Add AI-powered recommendation system

## Contact

For schema-related questions or issues, please refer to the main project documentation or create an issue in the repository.
