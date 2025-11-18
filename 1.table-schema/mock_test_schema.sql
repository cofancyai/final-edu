-- Mock Test System Database Schema
-- This schema supports comprehensive mock test functionality with test sessions, analytics, and history

-- Enable UUID extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Mock Tests table (stores test metadata)
CREATE TABLE mock_tests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  subject VARCHAR(100) NOT NULL,  -- e.g., "General Studies", "Current Affairs", "Aptitude"
  exam_type VARCHAR(50),  -- e.g., "UPSC Prelims", "SSC CGL", "Banking PO"
  duration_minutes INTEGER NOT NULL,  -- e.g., 120 for 2 hours
  total_questions INTEGER NOT NULL,
  total_marks NUMERIC(10,2) NOT NULL,
  passing_percentage NUMERIC(5,2) DEFAULT 33.33,  -- e.g., 33.33 for 33%
  difficulty_level VARCHAR(20) DEFAULT 'medium',  -- easy/medium/hard/mixed
  has_negative_marking BOOLEAN DEFAULT false,
  negative_marks_per_question NUMERIC(5,2) DEFAULT 0,  -- e.g., 0.33 for -1/3 marking
  instructions TEXT,  -- Test instructions/rules
  is_active BOOLEAN DEFAULT true,
  is_published BOOLEAN DEFAULT false,  -- Only published tests are visible to users
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Mock Test Questions table (stores questions for each mock test)
CREATE TABLE mock_test_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mock_test_id UUID NOT NULL REFERENCES mock_tests(id) ON DELETE CASCADE,
  question_number INTEGER NOT NULL,  -- Sequential number within the test (1, 2, 3...)
  question_text TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  option_e TEXT,  -- Optional 5th option for some exams
  correct_answer CHAR(1) NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D', 'E')),
  explanation TEXT,  -- Detailed explanation of the correct answer
  topic VARCHAR(100),  -- e.g., "Indian Polity", "Arithmetic", "Current Events"
  subject VARCHAR(100),  -- e.g., "History", "Mathematics", "English"
  difficulty VARCHAR(20) DEFAULT 'medium',  -- easy/medium/hard
  marks NUMERIC(5,2) DEFAULT 1.0,  -- Marks for this question
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(mock_test_id, question_number)
);

-- Create index for faster question retrieval
CREATE INDEX idx_mock_test_questions_test_id ON mock_test_questions(mock_test_id);
CREATE INDEX idx_mock_test_questions_topic ON mock_test_questions(topic);

-- Mock Test Attempts table (stores user test sessions)
CREATE TABLE mock_test_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,  -- Reference to users table (if you have one)
  mock_test_id UUID NOT NULL REFERENCES mock_tests(id) ON DELETE CASCADE,
  started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP WITH TIME ZONE,
  submitted_at TIMESTAMP WITH TIME ZONE,  -- When user clicked submit
  time_taken_seconds INTEGER,  -- Actual time taken (may be less than duration)
  status VARCHAR(20) DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed', 'abandoned', 'auto_submitted')),

  -- Results
  total_attempted INTEGER DEFAULT 0,
  total_correct INTEGER DEFAULT 0,
  total_incorrect INTEGER DEFAULT 0,
  total_unanswered INTEGER DEFAULT 0,
  score NUMERIC(10,2) DEFAULT 0,
  percentage NUMERIC(5,2) DEFAULT 0,

  -- Session data
  answers JSONB,  -- {question_id: "A", question_id: "B", ...}
  marked_for_review JSONB,  -- [question_id, question_id, ...]
  time_per_question JSONB,  -- {question_id: seconds_spent, ...}

  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for faster lookups
CREATE INDEX idx_mock_test_attempts_user_id ON mock_test_attempts(user_id);
CREATE INDEX idx_mock_test_attempts_test_id ON mock_test_attempts(mock_test_id);
CREATE INDEX idx_mock_test_attempts_status ON mock_test_attempts(status);
CREATE INDEX idx_mock_test_attempts_started_at ON mock_test_attempts(started_at DESC);

-- Mock Test Analytics table (optional - for detailed analytics)
CREATE TABLE mock_test_analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  attempt_id UUID NOT NULL REFERENCES mock_test_attempts(id) ON DELETE CASCADE,

  -- Subject-wise performance
  subject_breakdown JSONB,  -- {subject: {correct, incorrect, unanswered, accuracy}, ...}

  -- Topic-wise performance
  topic_breakdown JSONB,  -- {topic: {correct, incorrect, unanswered, accuracy}, ...}

  -- Difficulty-wise performance
  difficulty_breakdown JSONB,  -- {easy: {correct, total}, medium: {...}, hard: {...}}

  -- Time analysis
  avg_time_per_question NUMERIC(5,2),
  fastest_question_time INTEGER,  -- In seconds
  slowest_question_time INTEGER,

  -- Comparison metrics
  percentile NUMERIC(5,2),  -- User's percentile among all test takers
  rank INTEGER,  -- Rank among all test takers

  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_mock_test_analytics_attempt_id ON mock_test_analytics(attempt_id);

-- Mock Test Leaderboard table (optional - for competitive features)
CREATE TABLE mock_test_leaderboard (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mock_test_id UUID NOT NULL REFERENCES mock_tests(id) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  attempt_id UUID NOT NULL REFERENCES mock_test_attempts(id) ON DELETE CASCADE,
  score NUMERIC(10,2) NOT NULL,
  percentage NUMERIC(5,2) NOT NULL,
  time_taken_seconds INTEGER NOT NULL,
  rank INTEGER,
  completed_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(mock_test_id, user_id)  -- One entry per user per test (best attempt)
);

CREATE INDEX idx_mock_test_leaderboard_test_id ON mock_test_leaderboard(mock_test_id);
CREATE INDEX idx_mock_test_leaderboard_rank ON mock_test_leaderboard(rank);

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_mock_tests_updated_at
  BEFORE UPDATE ON mock_tests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mock_test_attempts_updated_at
  BEFORE UPDATE ON mock_test_attempts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) - Enable if using Supabase with authentication
-- ALTER TABLE mock_tests ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE mock_test_questions ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE mock_test_attempts ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE mock_test_analytics ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE mock_test_leaderboard ENABLE ROW LEVEL SECURITY;

-- RLS Policies (uncomment and customize based on your auth setup)
-- Public read for published tests
-- CREATE POLICY "Anyone can view published mock tests" ON mock_tests
--   FOR SELECT USING (is_published = true);

-- CREATE POLICY "Anyone can view questions for published tests" ON mock_test_questions
--   FOR SELECT USING (
--     EXISTS (SELECT 1 FROM mock_tests WHERE id = mock_test_id AND is_published = true)
--   );

-- Users can only see their own attempts
-- CREATE POLICY "Users can view own attempts" ON mock_test_attempts
--   FOR SELECT USING (auth.uid() = user_id);

-- CREATE POLICY "Users can create own attempts" ON mock_test_attempts
--   FOR INSERT WITH CHECK (auth.uid() = user_id);

-- CREATE POLICY "Users can update own attempts" ON mock_test_attempts
--   FOR UPDATE USING (auth.uid() = user_id);

-- Comments for documentation
COMMENT ON TABLE mock_tests IS 'Stores metadata for all mock tests';
COMMENT ON TABLE mock_test_questions IS 'Stores all questions for mock tests';
COMMENT ON TABLE mock_test_attempts IS 'Tracks user test sessions and results';
COMMENT ON TABLE mock_test_analytics IS 'Detailed analytics for each test attempt';
COMMENT ON TABLE mock_test_leaderboard IS 'Leaderboard rankings for competitive features';
