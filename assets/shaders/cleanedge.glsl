#define SLOPE
#define CLEANUP

extern vec3 highestColor;
extern float similarThreshold;
extern float lineWidth;
extern vec2 textureSize;

bool similar(vec4 col1, vec4 col2)
{
    return (col1.a == 0.0 && col2.a == 0.0)
        || distance(col1, col2) <= similarThreshold;
}

bool similar3(vec4 col1, vec4 col2, vec4 col3)
{
    return similar(col1, col2) && similar(col2, col3);
}

bool similar4(vec4 col1, vec4 col2, vec4 col3, vec4 col4)
{
    return similar(col1, col2)
        && similar(col2, col3)
        && similar(col3, col4);
}

bool similar5(vec4 col1, vec4 col2, vec4 col3, vec4 col4, vec4 col5)
{
    return similar(col1, col2)
        && similar(col2, col3)
        && similar(col3, col4)
        && similar(col4, col5);
}

bool higher(vec4 thisCol, vec4 otherCol)
{
    if (similar(thisCol, otherCol))
        return false;

    if (thisCol.a == otherCol.a)
    {
        return distance(thisCol.rgb, highestColor)
             < distance(otherCol.rgb, highestColor);
    }

    return thisCol.a > otherCol.a;
}

vec4 higherCol(vec4 thisCol, vec4 otherCol)
{
    return higher(thisCol, otherCol) ? thisCol : otherCol;
}

float cd(vec4 col1, vec4 col2)
{
    return distance(col1, col2);
}

float distToLine(vec2 testPt, vec2 pt1, vec2 pt2, vec2 dir)
{
    vec2 lineDir = pt2 - pt1;
    vec2 perpDir = vec2(lineDir.y, -lineDir.x);
    vec2 dirToPt1 = pt1 - testPt;

    return (dot(perpDir, dir) > 0.0 ? 1.0 : -1.0)
        * dot(normalize(perpDir), dirToPt1);
}

vec4 sliceDist(
    vec2 point,
    vec2 mainDir,
    vec2 pointDir,

    vec4 ub,
    vec4 u,
    vec4 uf,
    vec4 uff,

    vec4 b,
    vec4 c,
    vec4 f,
    vec4 ff,

    vec4 db,
    vec4 d,
    vec4 df,
    vec4 dff,

    vec4 ddb,
    vec4 dd,
    vec4 ddf
)
{
#ifdef SLOPE
    float minWidth = 0.45;
    float maxWidth = 1.142;
#else
    float minWidth = 0.0;
    float maxWidth = 1.4;
#endif

    float _lineWidth = max(minWidth, min(maxWidth, lineWidth));

    point = mainDir * (point - 0.5) + 0.5;

    float distAgainst =
        4.0 * cd(f, d)
        + cd(uf, c)
        + cd(c, db)
        + cd(ff, df)
        + cd(df, dd);

    float distTowards =
        4.0 * cd(c, df)
        + cd(u, f)
        + cd(f, dff)
        + cd(b, d)
        + cd(d, ddf);

    bool shouldSlice =
        (distAgainst < distTowards)
        || ((distAgainst < distTowards + 0.001) && !higher(c, f));

    if (
        similar4(f, d, b, u)
        && similar4(uf, df, db, ub)
        && !similar(c, f)
    )
    {
        shouldSlice = false;
    }

    if (!shouldSlice)
        return vec4(-1.0);

    float dist = 1.0;
    bool flip = false;
    vec2 center = vec2(0.5);

#ifdef SLOPE

    // Lower shallow 2:1 slant
    if (
        similar3(f, d, db)
        && !similar3(f, d, b)
        && !similar(uf, db)
    )
    {
        if (!(similar(c, df) && higher(c, f)))
        {
            if (higher(c, f))
                flip = true;

            if (similar(u, f) && !similar(c, df) && !higher(c, u))
                flip = true;
        }

        if (flip)
        {
            dist =
                _lineWidth -
                distToLine(
                    point,
                    center + vec2(1.5, -1.0) * pointDir,
                    center + vec2(-0.5, 0.0) * pointDir,
                    -pointDir
                );
        }
        else
        {
            dist =
                distToLine(
                    point,
                    center + vec2(1.5, 0.0) * pointDir,
                    center + vec2(-0.5, 1.0) * pointDir,
                    pointDir
                );
        }

#ifdef CLEANUP
        if (
            !flip
            && similar(c, uf)
            && !(
                similar3(c, uf, uff)
                && !similar3(c, uf, ff)
                && !similar(d, uff)
            )
        )
        {
            float dist2 =
                distToLine(
                    point,
                    center + vec2(2.0, -1.0) * pointDir,
                    center + vec2(0.0, 1.0) * pointDir,
                    pointDir
                );

            dist = min(dist, dist2);
        }
#endif

        dist -= _lineWidth / 2.0;

        return dist <= 0.0
            ? ((cd(c, f) <= cd(c, d)) ? f : d)
            : vec4(-1.0);
    }

    // Forward steep 2:1 slant
    else if (
        similar3(uf, f, d)
        && !similar3(u, f, d)
        && !similar(uf, db)
    )
    {
        if (!(similar(c, df) && higher(c, d)))
        {
            if (higher(c, d))
                flip = true;

            if (similar(b, d) && !similar(c, df) && !higher(c, d))
                flip = true;
        }

        if (flip)
        {
            dist =
                _lineWidth -
                distToLine(
                    point,
                    center + vec2(0.0, -0.5) * pointDir,
                    center + vec2(-1.0, 1.5) * pointDir,
                    -pointDir
                );
        }
        else
        {
            dist =
                distToLine(
                    point,
                    center + vec2(1.0, -0.5) * pointDir,
                    center + vec2(0.0, 1.5) * pointDir,
                    pointDir
                );
        }

#ifdef CLEANUP
        if (
            !flip
            && similar(c, db)
            && !(
                similar3(c, db, ddb)
                && !similar3(c, db, dd)
                && !similar(f, ddb)
            )
        )
        {
            float dist2 =
                distToLine(
                    point,
                    center + vec2(1.0, 0.0) * pointDir,
                    center + vec2(-1.0, 2.0) * pointDir,
                    pointDir
                );

            dist = min(dist, dist2);
        }
#endif

        dist -= _lineWidth / 2.0;

        return dist <= 0.0
            ? ((cd(c, f) <= cd(c, d)) ? f : d)
            : vec4(-1.0);
    }

    else
#endif

    // 45 degree diagonal
    if (similar(f, d))
    {
        if (similar(c, df) && higher(c, f))
        {
            if (!similar(c, dd) && !similar(c, ff))
                flip = true;
        }
        else
        {
            if (higher(c, f))
                flip = true;

            if (!similar(c, b) && similar4(b, f, d, u))
                flip = true;
        }

        if (
            (
                (similar(f, db) && similar3(u, f, df))
                || (similar(uf, d) && similar3(b, d, df))
            )
            && !similar(c, df)
        )
        {
            flip = true;
        }

        if (flip)
        {
            dist =
                _lineWidth -
                distToLine(
                    point,
                    center + vec2(1.0, -1.0) * pointDir,
                    center + vec2(-1.0, 1.0) * pointDir,
                    -pointDir
                );
        }
        else
        {
            dist =
                distToLine(
                    point,
                    center + vec2(1.0, 0.0) * pointDir,
                    center + vec2(0.0, 1.0) * pointDir,
                    pointDir
                );
        }

#ifdef SLOPE
#ifdef CLEANUP

        if (
            !flip
            && similar3(c, uf, uff)
            && !similar3(c, uf, ff)
            && !similar(d, uff)
        )
        {
            float dist2 =
                distToLine(
                    point,
                    center + vec2(1.5, 0.0) * pointDir,
                    center + vec2(-0.5, 1.0) * pointDir,
                    pointDir
                );

            dist = max(dist, dist2);
        }

        if (
            !flip
            && similar3(ddb, db, c)
            && !similar3(dd, db, c)
            && !similar(ddb, f)
        )
        {
            float dist2 =
                distToLine(
                    point,
                    center + vec2(1.0, -0.5) * pointDir,
                    center + vec2(0.0, 1.5) * pointDir,
                    pointDir
                );

            dist = max(dist, dist2);
        }

#endif
#endif

        dist -= _lineWidth / 2.0;

        return dist <= 0.0
            ? ((cd(c, f) <= cd(c, d)) ? f : d)
            : vec4(-1.0);
    }

#ifdef SLOPE

    // Far corner of shallow slant
    else if (
        similar3(ff, df, d)
        && !similar3(ff, df, c)
        && !similar(uff, d)
    )
    {
        if (!(similar(f, dff) && higher(f, ff)))
        {
            if (higher(f, ff))
                flip = true;

            if (similar(uf, ff) && !similar(f, dff) && !higher(f, uf))
                flip = true;
        }

        if (flip)
        {
            dist =
                _lineWidth -
                distToLine(
                    point,
                    center + vec2(2.5, -1.0) * pointDir,
                    center + vec2(0.5, 0.0) * pointDir,
                    -pointDir
                );
        }
        else
        {
            dist =
                distToLine(
                    point,
                    center + vec2(2.5, 0.0) * pointDir,
                    center + vec2(0.5, 1.0) * pointDir,
                    pointDir
                );
        }

        dist -= _lineWidth / 2.0;

        return dist <= 0.0
            ? ((cd(f, ff) <= cd(f, df)) ? ff : df)
            : vec4(-1.0);
    }

    // Far corner of steep slant
    else if (
        similar3(f, df, dd)
        && !similar3(c, df, dd)
        && !similar(f, ddb)
    )
    {
        if (!(similar(d, ddf) && higher(d, dd)))
        {
            if (higher(d, dd))
                flip = true;

            if (similar(db, dd) && !similar(d, ddf) && !higher(d, dd))
                flip = true;
        }

        if (flip)
        {
            dist =
                _lineWidth -
                distToLine(
                    point,
                    center + vec2(0.0, 0.5) * pointDir,
                    center + vec2(-1.0, 2.5) * pointDir,
                    -pointDir
                );
        }
        else
        {
            dist =
                distToLine(
                    point,
                    center + vec2(1.0, 0.5) * pointDir,
                    center + vec2(0.0, 2.5) * pointDir,
                    pointDir
                );
        }

        dist -= _lineWidth / 2.0;

        return dist <= 0.0
            ? ((cd(d, df) <= cd(d, dd)) ? df : dd)
            : vec4(-1.0);
    }

#endif

    return vec4(-1.0);
}

vec4 effect(
    vec4 vertexColor,
    Image tex,
    vec2 textureCoords,
    vec2 screenCoords
)
{
    vec2 size = textureSize;

    // Position in source-image pixel coordinates.
    vec2 pixelPos = textureCoords * size;

    vec2 local = fract(pixelPos);

    vec2 px = ceil(pixelPos) - 0.5;

    // GLSL's round() isn't available on every LÖVE backend.
    vec2 pointDir = floor(local + 0.5) * 2.0 - 1.0;

    // Convert pixel-space coordinate to UV.
    vec2 invSize = 1.0 / size;

#define SAMPLE(offset) Texel(tex, (px + (offset) * pointDir) * invSize)

    vec4 uub = SAMPLE(vec2(-1.0, -2.0));
    vec4 uu  = SAMPLE(vec2( 0.0, -2.0));
    vec4 uuf = SAMPLE(vec2( 1.0, -2.0));

    vec4 ubb = SAMPLE(vec2(-2.0, -2.0));
    vec4 ub  = SAMPLE(vec2(-1.0, -1.0));
    vec4 u   = SAMPLE(vec2( 0.0, -1.0));
    vec4 uf  = SAMPLE(vec2( 1.0, -1.0));
    vec4 uff = SAMPLE(vec2( 2.0, -1.0));

    vec4 bb = SAMPLE(vec2(-2.0, 0.0));
    vec4 b  = SAMPLE(vec2(-1.0, 0.0));
    vec4 c  = SAMPLE(vec2( 0.0, 0.0));
    vec4 f  = SAMPLE(vec2( 1.0, 0.0));
    vec4 ff = SAMPLE(vec2( 2.0, 0.0));

    vec4 dbb = SAMPLE(vec2(-2.0, 1.0));
    vec4 db  = SAMPLE(vec2(-1.0, 1.0));
    vec4 d   = SAMPLE(vec2( 0.0, 1.0));
    vec4 df  = SAMPLE(vec2( 1.0, 1.0));
    vec4 dff = SAMPLE(vec2( 2.0, 1.0));

    vec4 ddb = SAMPLE(vec2(-1.0, 2.0));
    vec4 dd  = SAMPLE(vec2( 0.0, 2.0));
    vec4 ddf = SAMPLE(vec2( 1.0, 2.0));

#undef SAMPLE

    vec4 col = c;

    vec4 c_col = sliceDist(
        local,
        vec2(1.0, 1.0),
        pointDir,
        ub, u, uf, uff,
        b, c, f, ff,
        db, d, df, dff,
        ddb, dd, ddf
    );

    vec4 b_col = sliceDist(
        local,
        vec2(-1.0, 1.0),
        pointDir,
        uf, u, ub, ubb,
        f, c, b, bb,
        df, d, db, dbb,
        ddf, dd, ddb
    );

    vec4 u_col = sliceDist(
        local,
        vec2(1.0, -1.0),
        pointDir,
        db, d, df, dff,
        b, c, f, ff,
        ub, u, uf, uff,
        uub, uu, uuf
    );

    if (c_col.r >= 0.0)
        col = c_col;

    if (b_col.r >= 0.0)
        col = b_col;

    if (u_col.r >= 0.0)
        col = u_col;

    return col * vertexColor;
}