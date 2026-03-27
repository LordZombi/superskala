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
     * Vygeneruje plynulú SVG cestu pomocou kvadratických Bézierových kriviek (metóda stredových bodov).
     * @param points - Pole bodov v percentuálnych súradniciach {x: 0-100, y: 0-100}.
     * @param imageDims - Rozmery obrázka v pixeloch.
     * @returns Reťazec pre atribút 'd' SVG cesty.
     */
    const generateSexyPathD = (points: Point[] | null, imageDims: Dimensions): string => {
        if (!points || points.length < 2 || imageDims.width <= 1) {
            return '';
        }

        const {width, height} = imageDims;

        // Prepočet bodov z % na absolútne pixely
        const pts = points.map(p => ({
            x: (p.x * width) / 100,
            y: (p.y * height) / 100
        }));

        const first = pts[0];
        const second = pts[1];
        if (!(first && second)) return '';

        // Začíname prvým bodom
        let d = `M ${first.x.toFixed(2)},${first.y.toFixed(2)}`;

        // Ak máme len dva body, vykreslíme rovnú čiaru
        if (pts.length === 2) {
            return d + ` L ${second.x.toFixed(2)},${second.y.toFixed(2)}`;
        }

        // Prechádzame bodmi a vytvárame krivky cez stredové body
        for (let i = 1; i < pts.length - 1; i++) {
            // Vypočítame stred medzi aktuálnym a nasledujúcim bodom
            const a = pts[i];
            const b = pts[i + 1];
            if (!(a && b)) continue;

            const xc = (a.x + b.x) / 2;
            const yc = (a.y + b.y) / 2;

            // Q [kontrolný bod] [koncový bod]
            // Kontrolný bod je náš kliknutý bod, koncový bod je stred cesty
            d += ` Q ${a.x.toFixed(2)},${a.y.toFixed(2)} ${xc.toFixed(2)},${yc.toFixed(2)}`;
        }

        // Spojíme posledný bod priamkou (aby čiara nekončila v "stredovom" bode)
        const last = pts[pts.length - 1];
        if (!last) return d;

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
        parsePathString
    };
};
