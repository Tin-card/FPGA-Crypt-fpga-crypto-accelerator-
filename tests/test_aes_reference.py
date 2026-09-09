from scripts.aes_reference import aes128_encrypt


TEST_VECTORS = [
    {
        "name": "NIST FIPS-197",
        "key": "000102030405060708090a0b0c0d0e0f",
        "plaintext": "00112233445566778899aabbccddeeff",
        "expected": "69c4e0d86a7b0430d8cdb78070b4c55a",
    },
    {
        "name": "Zero key / zero plaintext",
        "key": "00000000000000000000000000000000",
        "plaintext": "00000000000000000000000000000000",
        "expected": "66e94bd4ef8a2c3b884cfa59ca342b2e",
    },
    {
        "name": "Zero key / non-zero plaintext",
        "key": "00000000000000000000000000000000",
        "plaintext": "00000000000000000000000000000001",
        "expected": "58e2fccefa7e3061367f1d57a4e7455a",
    },
]


def test_aes128_vectors():
    for vector in TEST_VECTORS:
        result = aes128_encrypt(
            vector["key"],
            vector["plaintext"],
        )

        assert result == vector["expected"], (
            f'{vector["name"]} failed: '
            f'expected {vector["expected"]}, got {result}'
        )
