
/* Removes all diacritics and accents from a string */
export function RemoveDiacritics(data) {
    return !data ?
        '' :
        typeof data === 'string' ?
            data
                .replace(/έ/g, 'ε')
                .replace(/ύ/g, 'υ')
                .replace(/ό/g, 'ο')
                .replace(/ώ/g, 'ω')
                .replace(/ά/g, 'α')
                .replace(/ί/g, 'ι')
                .replace(/ή/g, 'η')
                .replace(/\n/g, ' ')
                .replace(/[á]/g, 'a')
                .replace(/[é]/g, 'e')
                .replace(/[í]/g, 'i')
                .replace(/[ó]/g, 'o')
                .replace(/[ú]/g, 'u')
                .replace(/[ñ]/g, 'n')
                .replace(/[Á]/g, 'A')
                .replace(/[É]/g, 'E')
                .replace(/[Í]/g, 'I')
                .replace(/[Ó]/g, 'O')
                .replace(/[Ú]/g, 'U')
                .replace(/[Ñ]/g, 'N')
                .replace(/[Ǹ]/g, 'N')
                .replace(/[ǹ]/g, 'n')
                .replace(/ê/g, 'e')
                .replace(/î/g, 'i')
                .replace(/ô/g, 'o')
                .replace(/è/g, 'e')
                .replace(/ï/g, 'i')
                .replace(/ü/g, 'u')
                .replace(/ã/g, 'a')
                .replace(/õ/g, 'o')
                .replace(/ç/g, 'c')
                .replace(/ì/g, 'i')
                .replace(/ū/g, 'u') :
            data;
};
