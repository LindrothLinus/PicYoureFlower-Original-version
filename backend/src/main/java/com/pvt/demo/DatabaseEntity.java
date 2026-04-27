package com.pvt.demo;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.time.LocalDateTime;

@Entity
public class DatabaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id; //long

    private String name;
    private String type;

    private LocalDateTime lastFeed;
    private LocalDateTime lastTalk;
    private LocalDateTime lastPlay;

    private Integer intervalFeed;
    private Integer intervalTalk;
    private Integer intervalPlay;

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public LocalDateTime getLastFeed() {
        return this.lastFeed;
    }

    public void setLastFeed(LocalDateTime lastFeed) {
        this.lastFeed = lastFeed;
    }

    public LocalDateTime getLastTalk() {
        return this.lastTalk;
    }

    public void setLastTalk(LocalDateTime lastTalk) {
        this.lastTalk = lastTalk;
    }

    public LocalDateTime getLastPlay() {
        return this.lastPlay;
    }

    public void setLastPlay(LocalDateTime lastPlay) {
        this.lastPlay = lastPlay;
    }

    public Integer getIntervalFeed() {
        return this.intervalFeed;
    }

    public void setIntervalFeed(Integer intervalFeed) {
        this.intervalFeed = intervalFeed;
    }

    public Integer getIntervalTalk() {
        return this.intervalTalk;
    }

    public void setIntervalTalk(Integer intervalTalk) {
        this.intervalTalk = intervalTalk;
    }

    public Integer getIntervalPlay() {
        return this.intervalPlay;
    }

    public void setIntervalPlay(Integer intervalPlay) {
        this.intervalPlay = intervalPlay;
    }
}