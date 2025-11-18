-- ExamBot Database Schema - Correct Version
-- This schema matches the ExamBot service expectations
-- Tables: exam_categories, topics, subtopics, questions

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- CLEANUP: Drop existing tables if they exist
-- This ensures a clean slate and prevents type conflicts
-- ============================================
DROP TABLE IF EXISTS test_session_answers CASCADE;
DROP TABLE IF EXISTS test_sessions CASCADE;
DROP TABLE IF EXISTS user_question_progress CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS subtopics CASCADE;
DROP TABLE IF EXISTS topics CASCADE;
DROP TABLE IF EXISTS exam_categories CASCADE;

-- Drop old/legacy tables if they exist
DROP TABLE IF EXISTS chapters CASCADE;
DROP TABLE IF EXISTS subjects CASCADE;
DROP TABLE IF EXISTS exams CASCADE;

-- ============================================
-- EXAM CATEGORIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS exam_categories (
  id SERIAL PRIMARY KEY,
  category_name TEXT NOT NULL UNIQUE,
  description TEXT,
  icon TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for active exams
CREATE INDEX IF NOT EXISTS idx_exam_categories_active ON exam_categories(is_active);
CREATE INDEX IF NOT EXISTS idx_exam_categories_name ON exam_categories(category_name);

-- ============================================
-- TOPICS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS topics (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for topic lookups
CREATE INDEX IF NOT EXISTS idx_topics_name ON topics(name);

-- ============================================
-- SUBTOPICS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS subtopics (
  id TEXT PRIMARY KEY,
  topic_id TEXT NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  file TEXT,
  icon TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for subtopic lookups
CREATE INDEX IF NOT EXISTS idx_subtopics_topic_id ON subtopics(topic_id);
CREATE INDEX IF NOT EXISTS idx_subtopics_name ON subtopics(name);

-- ============================================
-- QUESTIONS TABLE (Main Question Bank)
-- ============================================
CREATE TABLE IF NOT EXISTS questions (
  id TEXT PRIMARY KEY,
  exam TEXT NOT NULL,
  year INTEGER,
  topic TEXT,
  subtopic TEXT,
  topic_id TEXT,
  subtopic_id TEXT,
  question_number INTEGER,
  question TEXT NOT NULL,
  options TEXT[] NOT NULL, -- Array of options
  answer TEXT NOT NULL, -- Correct answer (A, B, C, or D)
  detailed_explanation TEXT,
  difficulty TEXT, -- Easy, Medium, Hard
  subject TEXT,
  tags TEXT[], -- Array of tags for filtering
  time_estimate INTEGER DEFAULT 60, -- Seconds
  file_source TEXT,
  question_type TEXT DEFAULT 'multiple_choice',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

  -- Foreign key constraints
  CONSTRAINT fk_questions_topic FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL,
  CONSTRAINT fk_questions_subtopic FOREIGN KEY (subtopic_id) REFERENCES subtopics(id) ON DELETE SET NULL
);

-- Indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_questions_exam ON questions(exam);
CREATE INDEX IF NOT EXISTS idx_questions_subject ON questions(subject);
CREATE INDEX IF NOT EXISTS idx_questions_topic_id ON questions(topic_id);
CREATE INDEX IF NOT EXISTS idx_questions_subtopic_id ON questions(subtopic_id);
CREATE INDEX IF NOT EXISTS idx_questions_year ON questions(year);
CREATE INDEX IF NOT EXISTS idx_questions_difficulty ON questions(difficulty);
CREATE INDEX IF NOT EXISTS idx_questions_exam_year ON questions(exam, year);
CREATE INDEX IF NOT EXISTS idx_questions_exam_subject ON questions(exam, subject);

-- Full-text search index for question search
CREATE INDEX IF NOT EXISTS idx_questions_question_search ON questions USING gin(to_tsvector('english', question));

-- ============================================
-- USER QUESTION PROGRESS TABLE (Optional)
-- ============================================
CREATE TABLE IF NOT EXISTS user_question_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL, -- References auth.users(id)
  question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,

  bookmarked BOOLEAN DEFAULT false,
  bookmarked_at TIMESTAMP WITH TIME ZONE,

  attempted BOOLEAN DEFAULT false,
  attempt_count INTEGER DEFAULT 0,
  correct_count INTEGER DEFAULT 0,
  incorrect_count INTEGER DEFAULT 0,

  last_attempted_at TIMESTAMP WITH TIME ZONE,
  last_answer TEXT,
  last_correct BOOLEAN,

  time_spent_seconds INTEGER DEFAULT 0,
  notes TEXT,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

  UNIQUE(user_id, question_id)
);

-- Indexes for user progress
CREATE INDEX IF NOT EXISTS idx_user_progress_user ON user_question_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_question ON user_question_progress(question_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_bookmarked ON user_question_progress(user_id, bookmarked) WHERE bookmarked = true;

-- ============================================
-- TEST SESSIONS TABLE (Optional)
-- ============================================
CREATE TABLE IF NOT EXISTS test_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,

  session_type TEXT NOT NULL, -- 'practice', 'timed_test', 'previous_year', 'chapter_test'
  exam TEXT,
  subject TEXT,
  topic_id TEXT,
  year INTEGER,

  total_questions INTEGER NOT NULL,
  total_marks DECIMAL(8,2),
  time_limit_seconds INTEGER,

  started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP WITH TIME ZONE,
  time_spent_seconds INTEGER,

  status TEXT DEFAULT 'in_progress', -- 'in_progress', 'completed', 'abandoned'

  score DECIMAL(8,2),
  correct_answers INTEGER DEFAULT 0,
  incorrect_answers INTEGER DEFAULT 0,
  skipped_answers INTEGER DEFAULT 0,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for test sessions
CREATE INDEX IF NOT EXISTS idx_test_sessions_user ON test_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_test_sessions_status ON test_sessions(status);
CREATE INDEX IF NOT EXISTS idx_test_sessions_exam ON test_sessions(exam);

-- ============================================
-- TEST SESSION ANSWERS TABLE (Optional)
-- ============================================
CREATE TABLE IF NOT EXISTS test_session_answers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES test_sessions(id) ON DELETE CASCADE,
  question_id TEXT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,

  question_number INTEGER NOT NULL,
  user_answer TEXT,
  correct_answer TEXT NOT NULL,
  is_correct BOOLEAN,
  is_flagged BOOLEAN DEFAULT false,

  time_spent_seconds INTEGER DEFAULT 0,
  answered_at TIMESTAMP WITH TIME ZONE,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

  UNIQUE(session_id, question_id)
);

-- Indexes for test session answers
CREATE INDEX IF NOT EXISTS idx_test_session_answers_session ON test_session_answers(session_id);
CREATE INDEX IF NOT EXISTS idx_test_session_answers_question ON test_session_answers(question_id);

-- ============================================
-- FUNCTIONS FOR AUTOMATIC TIMESTAMP UPDATES
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ language 'plpgsql';

-- ============================================
-- TRIGGERS FOR AUTOMATIC TIMESTAMP UPDATES
-- ============================================
DROP TRIGGER IF EXISTS update_exam_categories_updated_at ON exam_categories;
CREATE TRIGGER update_exam_categories_updated_at
  BEFORE UPDATE ON exam_categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_topics_updated_at ON topics;
CREATE TRIGGER update_topics_updated_at
  BEFORE UPDATE ON topics
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_subtopics_updated_at ON subtopics;
CREATE TRIGGER update_subtopics_updated_at
  BEFORE UPDATE ON subtopics
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_questions_updated_at ON questions;
CREATE TRIGGER update_questions_updated_at
  BEFORE UPDATE ON questions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_user_progress_updated_at ON user_question_progress;
CREATE TRIGGER update_user_progress_updated_at
  BEFORE UPDATE ON user_question_progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_test_sessions_updated_at ON test_sessions;
CREATE TRIGGER update_test_sessions_updated_at
  BEFORE UPDATE ON test_sessions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE exam_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE subtopics ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_question_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_session_answers ENABLE ROW LEVEL SECURITY;

-- Public read access for exam structure (anyone can view)
CREATE POLICY "Anyone can view exam categories" ON exam_categories
  FOR SELECT USING (is_active = true);

CREATE POLICY "Anyone can view topics" ON topics
  FOR SELECT USING (true);

CREATE POLICY "Anyone can view subtopics" ON subtopics
  FOR SELECT USING (true);

-- Questions are publicly readable (or restrict to authenticated users)
CREATE POLICY "Anyone can view questions" ON questions
  FOR SELECT USING (true);

-- Or use this for authenticated-only access:
-- CREATE POLICY "Authenticated users can view questions" ON questions
--   FOR SELECT TO authenticated USING (true);

-- Users can only access their own progress
CREATE POLICY "Users can view own progress" ON user_question_progress
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" ON user_question_progress
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" ON user_question_progress
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own progress" ON user_question_progress
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- Users can only access their own test sessions
CREATE POLICY "Users can view own test sessions" ON test_sessions
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own test sessions" ON test_sessions
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own test sessions" ON test_sessions
  FOR UPDATE TO authenticated
  USING (auth.uid() = user_id);

-- Users can only access their own test session answers
CREATE POLICY "Users can view own test session answers" ON test_session_answers
  FOR SELECT TO authenticated
  USING (session_id IN (SELECT id FROM test_sessions WHERE user_id = auth.uid()));

CREATE POLICY "Users can insert own test session answers" ON test_session_answers
  FOR INSERT TO authenticated
  WITH CHECK (session_id IN (SELECT id FROM test_sessions WHERE user_id = auth.uid()));

CREATE POLICY "Users can update own test session answers" ON test_session_answers
  FOR UPDATE TO authenticated
  USING (session_id IN (SELECT id FROM test_sessions WHERE user_id = auth.uid()));

-- ============================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================
COMMENT ON TABLE exam_categories IS 'Stores exam categories (UPSC, SSC, Banking, etc.)';
COMMENT ON TABLE topics IS 'Stores main topics across subjects';
COMMENT ON TABLE subtopics IS 'Stores subtopics under each topic';
COMMENT ON TABLE questions IS 'Main question bank with all metadata';
COMMENT ON TABLE user_question_progress IS 'Tracks user progress per question (bookmarks, attempts)';
COMMENT ON TABLE test_sessions IS 'Stores user test/practice sessions';
COMMENT ON TABLE test_session_answers IS 'Stores answers for each test session';

COMMENT ON COLUMN questions.options IS 'Array of answer options in order (e.g., ARRAY[''Option A'', ''Option B'', ''Option C'', ''Option D''])';
COMMENT ON COLUMN questions.answer IS 'Correct answer letter: A, B, C, or D';
COMMENT ON COLUMN questions.difficulty IS 'Question difficulty: Easy, Medium, or Hard';
COMMENT ON COLUMN questions.tags IS 'Additional tags for enhanced filtering (e.g., ARRAY[''tag1'', ''tag2''])';

-- ============================================
-- SAMPLE VERIFICATION QUERIES
-- ============================================
-- Run these after loading sample data to verify everything works

-- Count questions by exam
-- SELECT exam, COUNT(*) as question_count FROM questions GROUP BY exam ORDER BY question_count DESC;

-- Count questions by difficulty
-- SELECT difficulty, COUNT(*) FROM questions GROUP BY difficulty;

-- Get all active exam categories
-- SELECT * FROM exam_categories WHERE is_active = true ORDER BY category_name;

-- Get questions with joins
-- SELECT q.id, q.question, q.exam, q.subject, t.topic_name, s.subtopic_name
-- FROM questions q
-- LEFT JOIN topics t ON q.topic_id = t.id
-- LEFT JOIN subtopics s ON q.subtopic_id = s.id
-- LIMIT 10;

-- ============================================
-- END OF SCHEMA
-- ============================================
