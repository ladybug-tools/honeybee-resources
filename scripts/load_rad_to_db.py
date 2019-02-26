import sqlite3 as lite

sky_command = """CREATE TABLE IF NOT EXISTS Sky (
patch_id INT,
hoy INT,
value INT,
PRIMARY KEY(patch_id, hoy)
);"""

sky_insert_command = \
    """INSERT INTO sky (patch_id, hoy, value) VALUES (?, ?, ?);"""

dc_command = """CREATE TABLE IF NOT EXISTS dc (
point_id INT,
patch_id INT,
value Number,
PRIMARY KEY(point_id, patch_id)
);"""

mtx_insert_command = \
    """INSERT INTO dc (point_id, patch_id, value) VALUES (?, ?, ?);"""


def load_sky(db_file, sky_file):
    """Load radiance sky as a separate table to database."""
    db = lite.connect(db_file, isolation_level=None)
    # Set journal mode to WAL.
    db.execute('PRAGMA page_size = 4096;')
    db.execute('PRAGMA cache_size=10000;')
    db.execute('PRAGMA locking_mode=EXCLUSIVE;')
    db.execute('PRAGMA synchronous=OFF;')
    db.execute('PRAGMA journal_mode=WAL;')

    cursor = db.cursor()
    cursor.execute("PRAGMA busy_timeout = 60000")
    cursor.execute(sky_command)
    # insert results from files into database

    cursor.execute('BEGIN')
    with open(sky_file) as inf:
        for line in inf:
            if line.startswith('FORMAT='):
                inf.next()  # empty line
                break
            elif line.startswith('NCOMP='):
                ncomp = int(line.split('=')[-1])
            elif line.startswith('NROWS='):
                nrows = int(line.split('=')[-1])
            elif line.startswith('NCOLS='):
                ncols = int(line.split('=')[-1])

        row_num = 0
        for line_count in range((ncols + 1) * nrows):
            try:
                value = inf.next().split()[0]
            except IndexError:
                # extra line
                pass
            # hoy
            col_num = line_count % (ncols + 1)
            # patch number
            row_num = int(line_count / (ncols + 1))
            # print row_num, col_num
            cursor.execute(sky_insert_command, (row_num, col_num, value))

    cursor.execute('COMMIT')
    db.commit()


def load_dc_matrix(db_file, mtx_file, table_name):
    """Load radiance sky as a separate table to database."""
    dc_command = """CREATE TABLE IF NOT EXISTS %s (
    point_id INT,
    patch_id INT,
    value Number,
    PRIMARY KEY(point_id, patch_id)
    );""" % table_name

    mtx_insert_command = \
        """INSERT INTO %s (point_id, patch_id, value) VALUES (?, ?, ?);""" % table_name

    db = lite.connect(db_file, isolation_level=None)
    # Set journal mode to WAL.
    db.execute('PRAGMA page_size = 4096;')
    db.execute('PRAGMA cache_size=10000;')
    db.execute('PRAGMA locking_mode=EXCLUSIVE;')
    db.execute('PRAGMA synchronous=OFF;')
    db.execute('PRAGMA journal_mode=WAL;')

    cursor = db.cursor()
    cursor.execute("PRAGMA busy_timeout = 60000")
    cursor.execute(dc_command)

    # insert results from files into database
    cursor.execute('BEGIN')
    with open(mtx_file) as inf:
        for line in inf:
            if line.startswith('FORMAT='):
                inf.next()  # empty line
                break
            elif line.startswith('NCOMP='):
                ncomp = int(line.split('=')[-1])
            elif line.startswith('NROWS='):
                nrows = int(line.split('=')[-1])
            elif line.startswith('NCOLS='):
                ncols = int(line.split('=')[-1])

        for row_num, row in enumerate(inf):
            for count, value in enumerate(row.split('\t')):
                if count % ncomp == 0:
                    col_num = count / ncomp
                    if col_num == ncols:
                        # this is last tab in resulst.
                        continue
                    cursor.execute(mtx_insert_command, (row_num, col_num,
                                                        value))

    cursor.execute('COMMIT')
    db.commit()


def multiply_matrix(db_file):
    """Load radiance sky as a separate table to database."""
    mul_command = """
    SELECT sky.hoy, dc.point_id, SUM(sky.value*dc.value) AS value
    FROM sky, dc
    WHERE sky.patch_id = dc.patch_id
    GROUP BY sky.hoy, dc.point_id;
    """

    db = lite.connect(db_file, isolation_level=None)
    # Set journal mode to WAL.
    db.execute('PRAGMA page_size = 4096;')
    db.execute('PRAGMA cache_size=10000;')
    db.execute('PRAGMA locking_mode=EXCLUSIVE;')
    db.execute('PRAGMA synchronous=OFF;')
    db.execute('PRAGMA journal_mode=WAL;')

    cursor = db.cursor()
    cursor.execute("PRAGMA busy_timeout = 60000")
    cursor.execute('BEGIN')
    res = cursor.execute(mul_command)
    # for item in res:
    #     print(item)
    cursor.execute('COMMIT')
    db.commit()


if __name__ == '__main__':
    db_file = 'c:/ladybug/radiance_test.db'
    sky_file = r'C:\ladybug\honeybee_006\gridbased_daylightcoeff\sky\skymtx_vis_r1_1_725300_41.98_-87.92_0.0.smx'
    matrix_file = r'C:\ladybug\honeybee_006\gridbased_daylightcoeff\result\matrix\normal_honeybee_006..south_skylight..default.dc'
    matrix_file = r'C:\ladybug\honeybee_006\gridbased_daylightcoeff\result\direct..north_facing..dark_glass_0.25.ill'

    # load_sky(db_file, sky_file)
    load_dc_matrix(db_file, matrix_file, 'dark_glass_text')
    # multiply matrices
    # multiply_matrix(db_file)
