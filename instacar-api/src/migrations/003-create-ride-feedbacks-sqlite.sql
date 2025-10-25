-- Migration específica para SQLite: Create ride_feedbacks table
CREATE TABLE IF NOT EXISTS ride_feedbacks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rideId VARCHAR(255) NOT NULL,
    userId VARCHAR(255) NOT NULL,
    counterpartyId VARCHAR(255) NOT NULL,
    counterpartyName VARCHAR(255) NOT NULL,
    rating INTEGER NOT NULL,
    seatCount INTEGER NOT NULL,
    observations TEXT NOT NULL,
    from_location VARCHAR(255) NOT NULL,
    to_location VARCHAR(255) NOT NULL,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ride_feedbacks_user_id ON ride_feedbacks(userId);
CREATE INDEX IF NOT EXISTS idx_ride_feedbacks_ride_id ON ride_feedbacks(rideId);
CREATE INDEX IF NOT EXISTS idx_ride_feedbacks_counterparty_id ON ride_feedbacks(counterpartyId);
CREATE INDEX IF NOT EXISTS idx_ride_feedbacks_created_at ON ride_feedbacks(createdAt);
