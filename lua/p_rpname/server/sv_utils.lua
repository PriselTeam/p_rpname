local oSql = sql.Query

function sql.Query(query)
    sql.m_strError = nil

    return oSql(query)
end