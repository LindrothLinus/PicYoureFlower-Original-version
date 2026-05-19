package com.pvt.demo;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.time.LocalDateTime;

@Entity
public class DatabaseEntity {

    // template också.
    // almänn info
    // användare
    // x,y värde
    // utplacerad eller Inte
    // mall bara namn

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id; // long

    private String commonName;
    private String latinName;
    private String color;
    private LocalDateTime picTaken;
    private FlowerTemplate template;

    public FlowerTemplate getTemplate() {
        return this.template;
    }

    public void setTemplate(FlowerTemplate template) {
        this.template = template;
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCommonName() {
        return this.commonName;
    }

    public void setCommonName(String commonName) {
        this.commonName = commonName;
    }

    public String getLatinName() {
        return this.latinName;
    }

    public void setLatinName(String latinName) {
        this.latinName = latinName;
    }

    public String getColor() {
        return this.color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public LocalDateTime getPicTaken() {
        return this.picTaken;
    }

    public void setPicTaken(LocalDateTime picTaken) {
        this.picTaken = picTaken;
    }

}