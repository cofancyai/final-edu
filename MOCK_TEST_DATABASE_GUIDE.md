# Mock Test Database Implementation Guide

## Overview
This guide provides instructions for implementing the Mock Test system database schema and sample data for the PrepNX educational platform.

## Files Created

### 1. Database Schema
**Location:** `1.table-schema/mock_test_schema.sql`
**Size:** 186 lines
**Purpose:** Complete database schema for Mock Test system

### 2. Sample Data
**Location:** `2.sample-data/seed_mock_test_data.sql`
**Size:** 945 lines
**Purpose:** Seed data with 3 complete mock tests and questions

---

## Database Schema

### Tables Created

#### 1. `mock_tests` (Main test metadata)
Stores information about each mock test available in the system.

**Key Fields:**
- `id` - UUID primary key
- `code` - Unique identifier (e.g., 'upsc_prelims_mock_1')
- `name` - Display name
- `subject` - Subject/category
- `exam_type` - Type of exam (UPSC, SSC, Banking, etc.)
- `duration_minutes` - Time limit in minutes
- `total_questions` - Number of questions
- `total_marks` - Maximum marks
- `passing_percentage` - Pass threshold
- `has_negative_marking` - Boolean flag
- `negative_marks_per_question` - Deduction per wrong answer
- `is_published` - Controls visibility to users

#### 2. `mock_test_questions` (Questions for each test)
Stores all questions with options and explanations.

**Key Fields:**
- `mock_test_id` - Foreign key to mock_tests
- `question_number` - Sequential number (1, 2, 3...)
- `question_text` - The question
- `option_a`, `option_b`, `option_c`, `option_d`, `option_e` - Answer choices
- `correct_answer` - 'A', 'B', 'C', 'D', or 'E'
- `explanation` - Detailed explanation
- `topic` - Topic/category
- `subject` - Subject classification
- `difficulty` - easy/medium/hard
- `marks` - Points for this question

#### 3. `mock_test_attempts` (User test sessions)
Tracks each user's test attempt with results.

**Key Fields:**
- `user_id` - Reference to user
- `mock_test_id` - Which test was taken
- `started_at`, `completed_at`, `submitted_at` - Timestamps
- `time_taken_seconds` - Actual time spent
- `status` - 'in_progress', 'completed', 'abandoned', 'auto_submitted'
- `total_attempted`, `total_correct`, `total_incorrect` - Statistics
- `score`, `percentage` - Results
- `answers` - JSONB: {question_id: "A", ...}
- `marked_for_review` - JSONB: [question_ids]
- `time_per_question` - JSONB: {question_id: seconds}

#### 4. `mock_test_analytics` (Detailed performance analytics)
Stores detailed analytics for each test attempt.

**Key Fields:**
- `attempt_id` - Foreign key to mock_test_attempts
- `subject_breakdown` - JSONB with subject-wise performance
- `topic_breakdown` - JSONB with topic-wise performance
- `difficulty_breakdown` - JSONB with difficulty-wise stats
- `avg_time_per_question` - Average time spent
- `percentile` - User's ranking percentile
- `rank` - Overall rank

#### 5. `mock_test_leaderboard` (Rankings and competition)
Maintains leaderboard for each test.

**Key Fields:**
- `mock_test_id` - Which test
- `user_id` - User identifier
- `attempt_id` - Best attempt
- `score`, `percentage` - Performance metrics
- `time_taken_seconds` - Completion time
- `rank` - Position in leaderboard

---

## Sample Data Included

### Mock Test 1: UPSC Prelims Mock Test
- **Code:** `upsc_prelims_mock_1`
- **Questions:** 30 questions
- **Duration:** 120 minutes
- **Total Marks:** 60 (2 marks each)
- **Negative Marking:** Yes (0.66 marks deduction)
- **Subjects Covered:**
  - History (Q1-Q5)
  - Geography (Q6-Q10)
  - Polity (Q11-Q15)
  - Economy (Q16-Q20)
  - Science & Technology (Q21-Q25)
  - Current Affairs & Environment (Q26-Q30)

### Mock Test 2: SSC CGL Mock Test
- **Code:** `ssc_cgl_mock_1`
- **Questions:** 25 questions
- **Duration:** 60 minutes
- **Total Marks:** 50 (2 marks each)
- **Negative Marking:** Yes (0.50 marks deduction)
- **Sections:**
  - General Awareness (Q1-Q10)
  - Reasoning (Q11-Q18)
  - Quantitative Aptitude (Q19-Q25)

### Mock Test 3: Banking PO Mock Test
- **Code:** `banking_po_mock_1`
- **Questions:** 35 questions (10 provided as samples)
- **Duration:** 60 minutes
- **Total Marks:** 35 (1 mark each)
- **Negative Marking:** Yes (0.25 marks deduction)
- **Sections:**
  - Banking Awareness (Q1-Q10)
  - English Language (Q11-Q20) - TODO
  - Reasoning (Q21-Q27) - TODO
  - Quantitative Aptitude (Q28-Q35) - TODO

---

## Installation Instructions

### Step 1: Run Schema Creation
Execute the schema file first to create all tables:

```bash
# For Supabase (recommended)
psql -h your-supabase-host -U postgres -d postgres -f 1.table-schema/mock_test_schema.sql

# Or via Supabase Dashboard
# Copy contents of mock_test_schema.sql and paste in SQL Editor
```

### Step 2: Load Sample Data
After schema is created, load the sample data:

```bash
# For Supabase
psql -h your-supabase-host -U postgres -d postgres -f 2.sample-data/seed_mock_test_data.sql

# Or via Supabase Dashboard
# Copy contents of seed_mock_test_data.sql and paste in SQL Editor
```

### Step 3: Verify Installation
Check if data was loaded correctly:

```sql
-- Check mock tests
SELECT code, name, total_questions, duration_minutes
FROM mock_tests
WHERE is_published = true;

-- Check question count
SELECT mt.code, COUNT(mtq.id) as question_count
FROM mock_tests mt
LEFT JOIN mock_test_questions mtq ON mt.id = mtq.mock_test_id
GROUP BY mt.code;

-- Should return:
-- upsc_prelims_mock_1: 30 questions
-- ssc_cgl_mock_1: 25 questions
-- banking_po_mock_1: 10 questions (partial)
```

---

## Row Level Security (RLS)

The schema includes commented-out RLS policies. To enable security:

1. **Uncomment RLS enable commands** in schema file
2. **Customize policies** based on your authentication system
3. **Test policies** thoroughly before production

Example policies included:
- Public can view published tests
- Users can only see their own attempts
- Users can create/update their own attempts

---

## API Integration

### Recommended API Endpoints

#### GET `/api/mock-tests`
Fetch all available mock tests

**Response:**
```json
[
  {
    "id": "uuid",
    "code": "upsc_prelims_mock_1",
    "name": "UPSC Prelims Mock Test - 1",
    "subject": "General Studies",
    "duration_minutes": 120,
    "total_questions": 30,
    "total_marks": 60,
    "difficulty_level": "mixed"
  }
]
```

#### GET `/api/mock-tests/:testId`
Fetch specific test with questions

**Response:**
```json
{
  "test": { /* test metadata */ },
  "questions": [
    {
      "id": "uuid",
      "question_number": 1,
      "question_text": "Who among the following...",
      "option_a": "...",
      "option_b": "...",
      "option_c": "...",
      "option_d": "...",
      "marks": 2.0,
      "topic": "Ancient History"
      // Note: correct_answer excluded for active tests
    }
  ]
}
```

#### POST `/api/mock-tests/:testId/start`
Start a new test attempt

**Request:**
```json
{
  "user_id": "user-uuid"
}
```

**Response:**
```json
{
  "attempt_id": "uuid",
  "started_at": "2024-01-01T10:00:00Z",
  "duration_minutes": 120,
  "expires_at": "2024-01-01T12:00:00Z"
}
```

#### POST `/api/mock-tests/attempts/:attemptId/save`
Save answer during test (auto-save)

**Request:**
```json
{
  "question_id": "uuid",
  "selected_answer": "B",
  "time_spent": 45
}
```

#### POST `/api/mock-tests/attempts/:attemptId/submit`
Submit test for evaluation

**Request:**
```json
{
  "answers": {
    "question-uuid-1": "A",
    "question-uuid-2": "B",
    "question-uuid-3": "C"
  },
  "marked_for_review": ["question-uuid-5"],
  "time_per_question": {
    "question-uuid-1": 30,
    "question-uuid-2": 45
  }
}
```

**Response:**
```json
{
  "attempt_id": "uuid",
  "score": 42.0,
  "total_marks": 60.0,
  "percentage": 70.0,
  "total_correct": 24,
  "total_incorrect": 4,
  "total_unanswered": 2,
  "time_taken_seconds": 5400,
  "status": "completed"
}
```

#### GET `/api/mock-tests/attempts/:attemptId/results`
Get detailed results with correct answers

**Response:**
```json
{
  "attempt": { /* attempt details */ },
  "analytics": { /* subject/topic breakdown */ },
  "question_results": [
    {
      "question_id": "uuid",
      "question_number": 1,
      "user_answer": "B",
      "correct_answer": "B",
      "is_correct": true,
      "marks_awarded": 2.0,
      "explanation": "Chandragupta Maurya founded..."
    }
  ]
}
```

---

## Frontend Service Example

Create `frontend/src/services/mockTestService.ts`:

```typescript
const API_BASE = 'https://prepnx-backend.vercel.app/api';
const API_KEY = 'a1b2c3d4e5f6g7h8i9j0';

export const mockTestService = {
  // Get all available mock tests
  async getAvailableTests() {
    const response = await fetch(`${API_BASE}/mock-tests`, {
      headers: { 'x-api-key': API_KEY }
    });
    if (!response.ok) throw new Error('Failed to fetch tests');
    return response.json();
  },

  // Get test with questions
  async getTestById(testId: string) {
    const response = await fetch(`${API_BASE}/mock-tests/${testId}`, {
      headers: { 'x-api-key': API_KEY }
    });
    if (!response.ok) throw new Error('Failed to fetch test');
    return response.json();
  },

  // Start a new attempt
  async startTest(testId: string, userId: string) {
    const response = await fetch(`${API_BASE}/mock-tests/${testId}/start`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': API_KEY
      },
      body: JSON.stringify({ user_id: userId })
    });
    if (!response.ok) throw new Error('Failed to start test');
    return response.json();
  },

  // Submit test
  async submitTest(attemptId: string, data: any) {
    const response = await fetch(
      `${API_BASE}/mock-tests/attempts/${attemptId}/submit`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': API_KEY
        },
        body: JSON.stringify(data)
      }
    );
    if (!response.ok) throw new Error('Failed to submit test');
    return response.json();
  }
};
```

---

## TypeScript Interfaces

Create `frontend/src/types/mockTest.ts`:

```typescript
export interface MockTest {
  id: string;
  code: string;
  name: string;
  description: string;
  subject: string;
  exam_type: string;
  duration_minutes: number;
  total_questions: number;
  total_marks: number;
  passing_percentage: number;
  difficulty_level: 'easy' | 'medium' | 'hard' | 'mixed';
  has_negative_marking: boolean;
  negative_marks_per_question: number;
  instructions: string;
}

export interface MockTestQuestion {
  id: string;
  question_number: number;
  question_text: string;
  option_a: string;
  option_b: string;
  option_c: string;
  option_d: string;
  option_e?: string;
  correct_answer?: 'A' | 'B' | 'C' | 'D' | 'E'; // Only in results
  explanation: string;
  topic: string;
  subject: string;
  difficulty: 'easy' | 'medium' | 'hard';
  marks: number;
}

export interface MockTestAttempt {
  id: string;
  user_id: string;
  mock_test_id: string;
  started_at: string;
  completed_at?: string;
  submitted_at?: string;
  time_taken_seconds?: number;
  status: 'in_progress' | 'completed' | 'abandoned' | 'auto_submitted';
  total_attempted: number;
  total_correct: number;
  total_incorrect: number;
  total_unanswered: number;
  score: number;
  percentage: number;
  answers: Record<string, string>;
  marked_for_review: string[];
  time_per_question: Record<string, number>;
}
```

---

## Next Steps for Implementation

### Phase 1: Backend API (Priority)
1. Create API routes for mock tests
2. Implement test attempt logic
3. Add answer validation and scoring
4. Create analytics calculation functions

### Phase 2: Frontend Components
1. `MockTestSelection.tsx` - Browse available tests
2. `MockTestInterface.tsx` - Test-taking UI
3. `MockTestResults.tsx` - Results display
4. `MockTestReview.tsx` - Answer review

### Phase 3: Features
1. Auto-save functionality
2. Timer with auto-submit
3. Question palette with status colors
4. Keyboard navigation
5. Full-screen mode

### Phase 4: Analytics & History
1. Subject-wise analysis
2. Topic-wise breakdown
3. Comparison with previous attempts
4. Leaderboard integration

---

## Extending the Database

### Adding New Mock Tests
1. Insert into `mock_tests` table
2. Insert questions into `mock_test_questions`
3. Set `is_published = true` when ready
4. Update frontend to display new test

### Adding More Questions
Follow the pattern in `seed_mock_test_data.sql`:

```sql
INSERT INTO mock_test_questions (
  mock_test_id,
  question_number,
  question_text,
  option_a, option_b, option_c, option_d,
  correct_answer,
  explanation,
  topic,
  subject,
  difficulty,
  marks
) VALUES (
  (SELECT id FROM mock_tests WHERE code = 'your_test_code'),
  11,  -- Next question number
  'Your question here?',
  'Option A',
  'Option B',
  'Option C',
  'Option D',
  'B',  -- Correct answer
  'Detailed explanation...',
  'Topic name',
  'Subject name',
  'medium',
  2.0
);
```

---

## Performance Considerations

### Indexes Created
- `mock_test_questions.mock_test_id` - Fast question lookup
- `mock_test_questions.topic` - Topic-based filtering
- `mock_test_attempts.user_id` - User history
- `mock_test_attempts.mock_test_id` - Test statistics
- `mock_test_attempts.status` - Active tests filtering
- `mock_test_attempts.started_at` - Recent attempts

### Query Optimization Tips
1. Use `SELECT` with specific columns instead of `SELECT *`
2. Add pagination for test lists
3. Cache test questions after first fetch
4. Use indexes for filtering and sorting
5. Consider materialized views for leaderboards

---

## Security Considerations

1. **Never expose correct answers** before test submission
2. **Validate submission time** against allowed duration
3. **Prevent multiple active attempts** per user per test
4. **Implement rate limiting** on API endpoints
5. **Use Row Level Security** in production
6. **Sanitize user inputs** to prevent SQL injection
7. **Encrypt sensitive data** if needed

---

## Troubleshooting

### Common Issues

**Issue:** Questions not loading
**Solution:** Check if test is published (`is_published = true`)

**Issue:** Duplicate attempts created
**Solution:** Check for existing `in_progress` attempts before creating new one

**Issue:** Incorrect scores
**Solution:** Verify negative marking calculation logic

**Issue:** Timer not syncing
**Solution:** Use server time, not client time for validation

---

## Support & Contact

For questions or issues:
1. Check this documentation
2. Review inline SQL comments
3. Check frontend component documentation (CLAUDE.md)

---

## Changelog

### 2024-11-18
- Initial schema creation
- Added 3 sample mock tests
- Created 65 sample questions
- Documented API structure
- Added implementation guidelines

---

**Last Updated:** November 18, 2024
**Version:** 1.0
**Status:** Ready for Backend Integration
