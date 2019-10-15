/* Converts the parameter to sentence casing */
export function SentenceCase(value: string): string
{
    return value.toLowerCase().replace(/[a-z]/i, function (letter)
    {
        return letter.toUpperCase();
    }).trim();
};
