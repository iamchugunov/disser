function [flag, enu, dop, nev] = correct_h_for_enu_point(rd, enu, h, config)
    [b1, l1, h1] = enu2geodetic(enu(1), enu(2), enu(3), config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
    [x0, y0, z0] = geodetic2enu(b1, l1, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
    [enu, flag, dop, nev] = NavSolverRDinv(rd, config.posts, [x0;y0], z0);
    enu(3) = z0;
end

