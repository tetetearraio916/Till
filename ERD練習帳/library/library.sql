create table publisher (
    id integer not null,
    publisher varcher(100),
    primary key (id)
);

create table books (
    id integer not null ,
    book varchar (100),
    author varchar (100),
    price integer ,
    publisher_id integer not null ,
    year integer ,
    primary key (id),
    foreign key (publisher_id)
        references publisher (id)
                   on update restrict
);

create table subscriber (
    id integer  not null,
    name varchar (100),
    hurigana varchar (100),
    subscriber_number  integer ,
    primary key (id)
);

create table discover(
    id integer not null,
    newspaper_number integer ,
    newspaper_name varchar (100),
    newspaper_date date ,
    subscriber_id integer not null ,
    book_id integer not null,
    other varchar (100),
    primary (id),
    foreign key (subscriber_id)
                     references subscriber (id)
                     on update restrict,
    foreign key (book_id)
                     references books(id)
                     on update restrict
);

create table contact_method(
    id integer not null,
    contact_method varchar (100),
    primary key(id)
);

create table contact_information(
    id integer not null,
    subscriber_id integer not null,
    contact_method_id integer not null,
    number integer,
    primary key(id),
    foreign key (subscriber_id)
                                references subscriber(id)
                                on update restrict ,
    foreign key (contact_method_id)
                                references contact_method(id)
                                on update restrict
);

create table library(
    id integer not null,
    library varchar (100),
    primary key (id)
);

create table reservation(
    id integer not null,
    application_date date ,
    communication_status integer ,
    contact_information_id integer not null,
    library_id integer not null,
    book_id integer not null,
    contact_status integer ,
    primary key (id),
    foreign key (book_id)
                        references books(id)
                        on update restrict ,
    foreign key (library_id)
                        references library(id)
                        on update restrict ,
    foreign key (contact_information_id)
                        references contact_information(id)
                        on update restrict
);
