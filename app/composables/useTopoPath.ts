interface Point {
    x: number;
    y: number;
}

interface Dimensions {
    width: number;
    height: number;
}

export const useTopoPath = () => {
    /**
     * Transformuje percentuálny bod (0-100) na absolútne pixely.
     */
    const toAbsolute = (point: Point, dims: Dimensions): Point => ({
        x: (point.x * dims.width) / 100,
        y: (point.y * dims.height) / 100
    });

    /**
     * Teraz už len kreslí – očakáva body pretransformované na pixely.
     */
    const generateSexyPathD = (points: Point[] | null): string => {
        if (!points || points.length < 2) return '';

        const first = points[0]!;
        let d = `M ${first.x.toFixed(2)},${first.y.toFixed(2)}`;

        for (let i = 1; i < points.length - 1; i++) {
            const a = points[i]!;
            const b = points[i + 1]!;
            const xc = (a.x + b.x) / 2;
            const yc = (a.y + b.y) / 2;
            d += ` Q ${a.x.toFixed(2)},${a.y.toFixed(2)} ${xc.toFixed(2)},${yc.toFixed(2)}`;
        }

        const last = points[points.length - 1]!;
        d += ` L ${last.x.toFixed(2)},${last.y.toFixed(2)}`;

        return d;
    };
    /**
     * Parsovanie SVG reťazca z databázy (napr. 'M 10.00% 20.00% L ...') späť na pole bodov {x,y}.
     * Táto funkcia bola predtým v ClimbDetailSheet a teraz ju môžeme zdieľať.
     */
    const parsePathString = (path: string | null): Point[] => {
        if (!path) return [];
        return path.replace('M ', '').split(' L ').map(p => {
            const [x, y] = p.split('% ').map(val => parseFloat(val));
            return {x: x || 0, y: y || 0};
        });
    };

    return {
        generateSexyPathD,
        parsePathString,
        toAbsolute,
    };
};
