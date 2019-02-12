CREATE TABLE albums (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  band_id INTEGER NOT NULL,
  year INTEGER NOT NULL,
  live BOOLEAN NOT NULL DEFAULT false,

  FOREIGN KEY(band_id) REFERENCES bands(id)
);

CREATE TABLE bands (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE notes (
  id INTEGER PRIMARY KEY,
  content TEXT NOT NULL,
  track_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(track_id) REFERENCES tracks(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE tracks (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  album_id INTEGER NOT NULL,
  ord INTEGER NOT NULL,
  bonus BOOLEAN NOT NULL DEFAULT false,
  lyrics TEXT NOT NULL,

  FOREIGN KEY(album_id) REFERENCES albums(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255),
  session_token VARCHAR(255)
);


INSERT INTO
  bands (id, name )
VALUES
  (1, "the little a's"), (2, "THE BIG A's");