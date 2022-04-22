#
# This source file is part of the EdgeDB open source project.
#
# Copyright 2016-present MagicStack Inc. and the EdgeDB authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


## String operators

CREATE INFIX OPERATOR
std::`=` (l: std::str, r: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'eq';
    CREATE ANNOTATION std::description := 'Compare two values for equality.';
    SET volatility := 'Immutable';
    SET commutator := 'std::=';
    SET negator := 'std::!=';
    USING SQL OPERATOR r'=';
};


CREATE INFIX OPERATOR
std::`?=` (l: OPTIONAL std::str, r: OPTIONAL std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'coal_eq';
    CREATE ANNOTATION std::description :=
        'Compare two (potentially empty) values for equality.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


CREATE INFIX OPERATOR
std::`!=` (l: std::str, r: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'neq';
    CREATE ANNOTATION std::description := 'Compare two values for inequality.';
    SET volatility := 'Immutable';
    SET commutator := 'std::!=';
    SET negator := 'std::=';
    USING SQL OPERATOR r'<>';
};


CREATE INFIX OPERATOR
std::`?!=` (l: OPTIONAL std::str, r: OPTIONAL std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'coal_neq';
    CREATE ANNOTATION std::description :=
        'Compare two (potentially empty) values for inequality.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


# Concatenation.
CREATE INFIX OPERATOR
std::`++` (l: std::str, r: std::str) -> std::str {
    CREATE ANNOTATION std::identifier := 'concat';
    CREATE ANNOTATION std::description := 'String concatenation.';
    SET volatility := 'Immutable';
    USING SQL OPERATOR '||';
};


CREATE INFIX OPERATOR
std::`LIKE` (string: std::str, pattern: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'like';
    CREATE ANNOTATION std::description :=
        'Case-sensitive simple string matching.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


CREATE INFIX OPERATOR
std::`ILIKE` (string: std::str, pattern: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'ilike';
    CREATE ANNOTATION std::description :=
        'Case-insensitive simple string matching.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


CREATE INFIX OPERATOR
std::`NOT LIKE` (string: std::str, pattern: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'not_like';
    CREATE ANNOTATION std::description :=
        'Case-sensitive simple string matching.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


CREATE INFIX OPERATOR
std::`NOT ILIKE` (string: std::str, pattern: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'not_ilike';
    CREATE ANNOTATION std::description :=
        'Case-insensitive simple string matching.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


CREATE INFIX OPERATOR
std::`<` (l: std::str, r: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'lt';
    CREATE ANNOTATION std::description := 'Less than.';
    SET volatility := 'Immutable';
    SET commutator := 'std::>';
    SET negator := 'std::>=';
    USING SQL OPERATOR r'<';
};


CREATE INFIX OPERATOR
std::`<=` (l: std::str, r: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'lte';
    CREATE ANNOTATION std::description := 'Less than or equal.';
    SET volatility := 'Immutable';
    SET commutator := 'std::>=';
    SET negator := 'std::>';
    USING SQL OPERATOR r'<=';
};


CREATE INFIX OPERATOR
std::`>` (l: std::str, r: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'gt';
    CREATE ANNOTATION std::description := 'Greater than.';
    SET volatility := 'Immutable';
    SET commutator := 'std::<';
    SET negator := 'std::<=';
    USING SQL OPERATOR r'>';
};


CREATE INFIX OPERATOR
std::`>=` (l: std::str, r: std::str) -> std::bool {
    CREATE ANNOTATION std::identifier := 'gte';
    CREATE ANNOTATION std::description := 'Greater than or equal.';
    SET volatility := 'Immutable';
    SET commutator := 'std::<=';
    SET negator := 'std::<';
    USING SQL OPERATOR r'>=';
};

CREATE INFIX OPERATOR
std::`[]` (l: std::str, r: std::int64) -> std::str {
    CREATE ANNOTATION std::identifier := 'index';
    CREATE ANNOTATION std::description := 'String indexing.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};

CREATE INFIX OPERATOR
std::`[]` (l: std::str, r: tuple<std::int64, std::int64>) -> std::str {
    CREATE ANNOTATION std::identifier := 'slice';
    CREATE ANNOTATION std::description := 'String slicing.';
    SET volatility := 'Immutable';
    USING SQL EXPRESSION;
};


## String functions


CREATE FUNCTION
std::str_repeat(s: std::str, n: std::int64) -> std::str
{
    CREATE ANNOTATION std::description :=
        'Repeat the input *string* *n* times.';
    SET volatility := 'Immutable';
    USING SQL $$
    SELECT repeat("s", "n"::int4)
    $$;
};


CREATE FUNCTION
std::str_lower(s: std::str) -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return a lowercase copy of the input *string*.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'lower';
};


CREATE FUNCTION
std::str_upper(s: std::str) -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return an uppercase copy of the input *string*.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'upper';
};


CREATE FUNCTION
std::str_title(s: std::str) -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return a titlecase copy of the input *string*.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'initcap';
};


CREATE FUNCTION
std::str_pad_start(s: std::str, n: std::int64, fill: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string padded at the start to the length *n*.';
    SET volatility := 'Immutable';
    USING SQL $$
    SELECT lpad("s", "n"::int4, "fill")
    $$;
};


CREATE FUNCTION
std::str_lpad(s: std::str, n: std::int64, fill: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string left-padded to the length *n*.';
    CREATE ANNOTATION std::deprecated :=
        'This function is deprecated and is scheduled \
         to be removed before 1.0.\n\
         Use std::str_pad_start() instead.';
    SET volatility := 'Immutable';
    USING (std::str_pad_start(s, n, fill));
};


CREATE FUNCTION
std::str_pad_end(s: std::str, n: std::int64, fill: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string padded at the end to the length *n*.';
    SET volatility := 'Immutable';
    USING SQL $$
    SELECT rpad("s", "n"::int4, "fill")
    $$;
};


CREATE FUNCTION
std::str_rpad(s: std::str, n: std::int64, fill: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string right-padded to the length *n*.';
    CREATE ANNOTATION std::deprecated :=
        'This function is deprecated and is scheduled \
         to be removed before 1.0.\n\
         Use std::str_pad_end() instead.';
    SET volatility := 'Immutable';
    USING (std::str_pad_end(s, n, fill));
};


CREATE FUNCTION
std::str_trim_start(s: std::str, tr: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string with all *trim* characters removed from \
         its start.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'ltrim';
};


CREATE FUNCTION
std::str_ltrim(s: std::str, tr: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string with all leftmost *trim* characters removed.';
    CREATE ANNOTATION std::deprecated :=
        'This function is deprecated and is scheduled \
         to be removed before 1.0.\n\
         Use std::str_trim_start() instead.';
    SET volatility := 'Immutable';
    USING (std::str_trim_start(s, tr));
};


CREATE FUNCTION
std::str_trim_end(s: std::str, tr: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string with all *trim* characters removed from \
         its end.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'rtrim';
};


CREATE FUNCTION
std::str_rtrim(s: std::str, tr: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string with all rightmost *trim* characters removed.';
    CREATE ANNOTATION std::deprecated :=
        'This function is deprecated and is scheduled \
         to be removed before 1.0.\n\
         Use std::str_trim_end() instead.';
    SET volatility := 'Immutable';
    USING (std::str_trim_end(s, tr));
};


CREATE FUNCTION
std::str_trim(s: std::str, tr: std::str=' ') -> std::str
{
    CREATE ANNOTATION std::description :=
        'Return the input string with *trim* characters removed from \
         both ends.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'btrim';
};


CREATE FUNCTION
std::str_split(s: std::str, delimiter: std::str) -> array<std::str>
{
    CREATE ANNOTATION std::description :=
        'Split string into array elements using the supplied delimiter.';
    SET volatility := 'Immutable';
    USING SQL $$
        SELECT (
            CASE WHEN "delimiter" != ''
            THEN string_to_array("s", "delimiter")
            ELSE regexp_split_to_array("s", '')
            END
        );
    $$;
};


CREATE FUNCTION
std::str_replace(s: std::str, old: std::str, new: std::str) -> std::str
{
    CREATE ANNOTATION std::description :=
        'Given a string, find a matching substring and replace all its \
        occurrences with a new substring.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'replace';
};


CREATE FUNCTION
std::str_reverse(s: std::str) -> std::str
{
    CREATE ANNOTATION std::description :=
        'Reverse the order of the characters in the string.';
    SET volatility := 'Immutable';
    USING SQL FUNCTION 'reverse';
};