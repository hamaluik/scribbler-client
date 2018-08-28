enum Result<R, E> {
    Ok(r:R);
    Pending;
    Err(e:E);
}