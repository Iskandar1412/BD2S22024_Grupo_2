--01 InsertArtistCreditName
CREATE PROCEDURE InsertArtistCreditName
    @artist_credit_id INT,
    @artist_id INT,
    @position INT
AS
BEGIN
    INSERT INTO ArtistCreditName (artist_credit_id, artist_id, position)
    VALUES (@artist_credit_id, @artist_id, @position);
END;

--02 InsertCountry
CREATE PROCEDURE InsertCountry
    @name NVARCHAR(255),
    @iso_code NVARCHAR(10)
AS
BEGIN
    INSERT INTO Country (name, iso_code)
    VALUES (@name, @iso_code);
END;

--03 InsertArtist
CREATE PROCEDURE InsertArtist
    @name NVARCHAR(255),
    @sort_name NVARCHAR(255),
    @begin_date DATE,
    @end_date DATE,
    @type NVARCHAR(100),
    @gender NVARCHAR(50),
    @country_id INT,
    @area NVARCHAR(255),
    @description NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Artist (name, sort_name, begin_date, end_date, type, gender, country_id, area, description)
    VALUES (@name, @sort_name, @begin_date, @end_date, @type, @gender, @country_id, @area, @description);
END;

--04 InsertArtistCredit
CREATE PROCEDURE InsertArtistCredit
    @name NVARCHAR(255)
AS
BEGIN
    INSERT INTO ArtistCredit (name)
    VALUES (@name);
END;

--05 InsertAlbum
CREATE PROCEDURE InsertAlbum
    @title NVARCHAR(255),
    @release_date DATE,
    @artist_id INT
AS
BEGIN
    INSERT INTO Album (title, release_date, artist_id)
    VALUES (@title, @release_date, @artist_id);
END;

--06 InsertRecording
CREATE PROCEDURE InsertRecording
    @title NVARCHAR(255),
    @length TIME,
    @artist_credit_id INT
AS
BEGIN
    INSERT INTO Recording (title, length, artist_credit_id)
    VALUES (@title, @length, @artist_credit_id);
END;

--07 InsertTrack
CREATE PROCEDURE InsertTrack
    @title NVARCHAR(255),
    @duration TIME,
    @album_id INT,
    @recording_id INT,
    @rating FLOAT
AS
BEGIN
    INSERT INTO Track (title, duration, album_id, recording_id, rating)
    VALUES (@title, @duration, @album_id, @recording_id, @rating);
END;

--08 InsertGenre
CREATE PROCEDURE InsertGenre
    @name NVARCHAR(100)
AS
BEGIN
    INSERT INTO Genre (name)
    VALUES (@name);
END;

--09 InsertArtistGenre
CREATE PROCEDURE InsertArtistGenre
    @artist_id INT,
    @genre_id INT
AS
BEGIN
    INSERT INTO ArtistGenre (artist_id, genre_id)
    VALUES (@artist_id, @genre_id);
END;

--10 InsertTrackGenre
CREATE PROCEDURE InsertTrackGenre
    @track_id INT,
    @genre_id INT
AS
BEGIN
    INSERT INTO TrackGenre (track_id, genre_id)
    VALUES (@track_id, @genre_id);
END;

--11 InsertArtistAlias
CREATE PROCEDURE InsertArtistAlias
    @artist_id INT,
    @alias NVARCHAR(255),
    @sort_name NVARCHAR(255)
AS
BEGIN
    INSERT INTO ArtistAlias (artist_id, alias, sort_name)
    VALUES (@artist_id, @alias, @sort_name);
END;

--12 InsertLabel
CREATE PROCEDURE InsertLabel
    @name NVARCHAR(255),
    @country_id INT,
    @established_date DATE,
    @description NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO Label (name, country_id, established_date, description)
    VALUES (@name, @country_id, @established_date, @description);
END;

--13 InsertAlbumLabel
CREATE PROCEDURE InsertAlbumLabel
    @album_id INT,
    @label_id INT
AS
BEGIN
    INSERT INTO AlbumLabel (album_id, label_id)
    VALUES (@album_id, @label_id);
END;

--14 InsertCopyright
CREATE PROCEDURE InsertCopyright
    @copyright_holder NVARCHAR(255),
    @copyright_year INT,
    @copyright_notice NVARCHAR(MAX),
    @type NVARCHAR(50)
AS
BEGIN
    INSERT INTO Copyright (copyright_holder, copyright_year, copyright_notice, type)
    VALUES (@copyright_holder, @copyright_year, @copyright_notice, @type);
END;

--15 InsertAlbumCopyright
CREATE PROCEDURE InsertAlbumCopyright
    @album_id INT,
    @copyright_id INT
AS
BEGIN
    INSERT INTO AlbumCopyright (album_id, copyright_id)
    VALUES (@album_id, @copyright_id);
END;

--16 InsertTrackCopyright
CREATE PROCEDURE InsertTrackCopyright
    @track_id INT,
    @copyright_id INT
AS
BEGIN
    INSERT INTO TrackCopyright (track_id, copyright_id)
    VALUES (@track_id, @copyright_id);
END;

--17 InsertTag
CREATE PROCEDURE InsertTag
    @name NVARCHAR(100)
AS
BEGIN
    INSERT INTO Tag (name)
    VALUES (@name);
END;

--18 InsertArtistTag
CREATE PROCEDURE InsertArtistTag
    @artist_id INT,
    @tag_id INT
AS
BEGIN
    INSERT INTO ArtistTag (artist_id, tag_id)
    VALUES (@artist_id, @tag_id);
END;

--19 InsertAlbumTag
CREATE PROCEDURE InsertAlbumTag
    @album_id INT,
    @tag_id INT
AS
BEGIN
    INSERT INTO AlbumTag (album_id, tag_id)
    VALUES (@album_id, @tag_id);
END;

--20 InsertTrackTag
CREATE PROCEDURE InsertTrackTag
    @track_id INT,
    @tag_id INT
AS
BEGIN
    INSERT INTO TrackTag (track_id, tag_id)
    VALUES (@track_id, @tag_id);
END;

--21 InsertReleaseGroup
CREATE PROCEDURE InsertReleaseGroup
    @title NVARCHAR(255),
    @artist_credit_id INT,
    @type NVARCHAR(100)
AS
BEGIN
    INSERT INTO ReleaseGroup (title, artist_credit_id, type)
    VALUES (@title, @artist_credit_id, @type);
END;

--22 InsertRelease
CREATE PROCEDURE InsertRelease
    @title NVARCHAR(255),
    @release_group_id INT,
    @artist_credit_id INT,
    @release_date DATE,
    @label_id INT,
    @country_id INT
AS
BEGIN
    INSERT INTO Release (title, release_group_id, artist_credit_id, release_date, label_id, country_id)
    VALUES (@title, @release_group_id, @artist_credit_id, @release_date, @label_id, @country_id);
END;

--23 InsertMedium
CREATE PROCEDURE InsertMedium
    @release_id INT,
    @format NVARCHAR(100),
    @position INT
AS
BEGIN
    INSERT INTO Medium (release_id, format, position)
    VALUES (@release_id, @format, @position);
END;

--24 InsertRating
CREATE PROCEDURE InsertRating
    @track_id INT,
    @user_id INT,
    @rating INT
AS
BEGIN
    INSERT INTO Rating (track_id, user_id, rating)
    VALUES (@track_id, @user_id, @rating);
END;
