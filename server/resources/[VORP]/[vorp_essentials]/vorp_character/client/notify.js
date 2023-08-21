
exports('_UI_FEED_POST_OBJECTIVE', (duration, text) => {
    const struct1 = new DataView(new ArrayBuffer(96));
    struct1.setInt32(0 * 8, duration, true);

    const struct2 = new DataView(new ArrayBuffer(64));
    struct2.setBigInt64(1 * 8, BigInt(CreateVarString(10, "LITERAL_STRING", text)), true);

    Citizen.invokeNative("0xCEDBF17EFCC0E4A4", struct1, struct2, 1, 1);
});