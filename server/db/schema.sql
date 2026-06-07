// Database schema SQL

const schema = `
-- Users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nickname VARCHAR(255) NOT NULL,
  avatar VARCHAR(255) DEFAULT '👨‍💻',
  points INTEGER DEFAULT 0,
  wins INTEGER DEFAULT 0,
  games_played INTEGER DEFAULT 0,
  accuracy FLOAT DEFAULT 0,
  rank INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  last_seen TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Rooms table
CREATE TABLE IF NOT EXISTS rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(6) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  host_id UUID NOT NULL REFERENCES users(id),
  game VARCHAR(50) NOT NULL,
  max_players INTEGER DEFAULT 8,
  is_private BOOLEAN DEFAULT FALSE,
  is_started BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Room players (many-to-many)
CREATE TABLE IF NOT EXISTS room_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  is_ready BOOLEAN DEFAULT FALSE,
  current_points INTEGER DEFAULT 0,
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(room_id, user_id)
);

-- Matches table
CREATE TABLE IF NOT EXISTS matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES rooms(id),
  game VARCHAR(50) NOT NULL,
  started_at TIMESTAMP DEFAULT NOW(),
  ended_at TIMESTAMP,
  winner_id UUID REFERENCES users(id),
  total_rounds INTEGER DEFAULT 0,
  status VARCHAR(50) DEFAULT 'in_progress'
);

-- Match players (many-to-many with scores)
CREATE TABLE IF NOT EXISTS match_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  final_score INTEGER DEFAULT 0,
  placement INTEGER,
  joined_at TIMESTAMP DEFAULT NOW()
);

-- Scores table (round-by-round)
CREATE TABLE IF NOT EXISTS scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  match_id UUID NOT NULL REFERENCES matches(id),
  round_number INTEGER NOT NULL,
  points_earned INTEGER DEFAULT 0,
  action VARCHAR(255),
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Leaderboard (materialized view or aggregated)
CREATE TABLE IF NOT EXISTS leaderboard (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES users(id),
  rank INTEGER,
  total_wins INTEGER DEFAULT 0,
  total_points INTEGER DEFAULT 0,
  total_games INTEGER DEFAULT 0,
  win_rate FLOAT DEFAULT 0,
  last_updated TIMESTAMP DEFAULT NOW()
);

-- Game history
CREATE TABLE IF NOT EXISTS game_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  match_id UUID NOT NULL REFERENCES matches(id),
  game_type VARCHAR(50) NOT NULL,
  result VARCHAR(50),
  points_earned INTEGER DEFAULT 0,
  played_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_users_rank ON users(rank);
CREATE INDEX idx_rooms_code ON rooms(code);
CREATE INDEX idx_rooms_host ON rooms(host_id);
CREATE INDEX idx_room_players_room ON room_players(room_id);
CREATE INDEX idx_room_players_user ON room_players(user_id);
CREATE INDEX idx_matches_room ON matches(room_id);
CREATE INDEX idx_matches_game ON matches(game);
CREATE INDEX idx_match_players_match ON match_players(match_id);
CREATE INDEX idx_match_players_user ON match_players(user_id);
CREATE INDEX idx_scores_user ON scores(user_id);
CREATE INDEX idx_scores_match ON scores(match_id);
CREATE INDEX idx_leaderboard_rank ON leaderboard(rank);
CREATE INDEX idx_game_history_user ON game_history(user_id);
CREATE INDEX idx_game_history_match ON game_history(match_id);

-- Enable real-time subscriptions
ALTER TABLE rooms REPLICA IDENTITY FULL;
ALTER TABLE room_players REPLICA IDENTITY FULL;
ALTER TABLE matches REPLICA IDENTITY FULL;
ALTER TABLE scores REPLICA IDENTITY FULL;
ALTER TABLE users REPLICA IDENTITY FULL;
`;

export default schema;
